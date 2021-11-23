uniform sampler2D shadowtex0;

struct shadowInfo {
	vec3  pos;   // Shadow Position (Schadow Space)
	float bias;  // Shadow Bias
	float diff;  // Diffuse (NdotL)
	float res;   // Shadow Resolution
};

float getPenumbra(float blockerDist, float lightSize) {
	return blockerDist * lightSize;
}

bool isShadow(vec3 shadowPos, float NdotL) {
	if (NdotL > 0.0 && saturate(shadowPos.xyz) == shadowPos.xyz) {

		float shadowDepth = texture2D(shadowtex0, shadowPos.xy).x;
		return shadowPos.z > shadowDepth;

	} else {
		return false;
	}
}
bool isShadow(vec4 shadowPos) {
	if (shadowPos.w > 0.0 && saturate(shadowPos.xyz) == shadowPos.xyz) {

		float shadowDepth = texture2D(shadowtex0, shadowPos.xy).x;
		return shadowPos.z > shadowDepth;

	} else {
		return false;
	}
}

float PCF(shadowInfo shadow, float r, float dither, int samples) {
	float cosN   = cos(dither);
	float sinN   = sin(dither);
	mat2  rot    = mat2(cosN, -sinN, cosN, sinN) * (r / shadow.res);

	float shadowAmount = 0.0;
	for (int i = 0; i < samples; i++) {
		vec2  offs        = rot * blue_noise_disk[i];
		float shadowDepth = texture(shadowtex0, shadow.pos.xy + offs).x;
		float bias        = shadow.bias * (manhattan(blue_noise_disk[i]) * r * 3 + 1); 
		float shadowZ     = shadow.pos.z - bias;
		shadowAmount   += float(shadowDepth < shadowZ);
	}
	return shadowAmount / samples;
}

float shadowPCF(shadowInfo shadow, float r, float dither) {
	if (shadow.diff > 0.0 && saturate(shadow.pos.xyz) == shadow.pos.xyz) {
		return PCF(shadow, r, dither, 4);
	} else {
		return 0.0;
	}
}


float blockerSearchPCSS(shadowInfo shadow, int dither, float radius) {

	float blocker = 1.0;
	for (int i = dither; i <= 16 + dither; i++) {
		vec2 offs = blue_noise_disk[i] * (radius / shadow.res);
		blocker   = min(blocker, texture(shadowtex0, shadow.pos.xy + offs).x);
	}

	return saturate(shadow.pos.z - blocker);
}


float shadowPCSS(shadowInfo shadow, float dither, float radius) {
	if (shadow.diff > 0.0 && saturate(shadow.pos.xyz) == shadow.pos.xyz) {

		float block  = blockerSearchPCSS(shadow, int(dither * 8), radius);
		float penum  = min(getPenumbra(block, shadow.res * 0.5), radius);
		
		return PCF(shadow, penum, dither, 4);

	} else {
		return 0.0;
	}
}