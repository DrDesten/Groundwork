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


float shadowPCF(vec4 shadowPos, float r, float shadowRes, float dither) {
	if (shadowPos.w > 0.0 && saturate(shadowPos.xyz) == shadowPos.xyz) {

		float cosN   = cos(dither);
		float sinN   = sin(dither);
		mat2  rot    = mat2(cosN, -sinN, cosN, sinN) * (r / shadowRes);

		float shadow = 0.0;
		for (int i = 0; i < 16; i++) {
			vec2 offs = rot * blue_noise_disk[i];
			shadow   += float(texture(shadowtex0, shadowPos.xy + offs).x < shadowPos.z);
		}
		return shadow / 16;

	} else {
		return 1.0;
	}
}

float PCF(shadowInfo shadow, float r, float dither) {
	float cosN   = cos(dither);
	float sinN   = sin(dither);
	mat2  rot    = mat2(cosN, -sinN, cosN, sinN) * (r / shadow.res);

	float shadowAmount = 0.0;
	for (int i = 0; i < 16; i++) {
		vec2  offs        = rot * blue_noise_disk[i];
		float shadowDepth = texture(shadowtex0, shadow.pos.xy + offs).x;
		float bias        = shadow.bias * (manhattan(blue_noise_disk[i]) * r * 3 + 1); 
		float shadowZ     = shadow.pos.z - bias;
		shadowAmount   += float(shadowDepth < shadowZ);
	}
	return shadowAmount / 16;
}

float shadowPCF(shadowInfo shadow, float r, float dither) {
	if (shadow.diff > 0.0 && saturate(shadow.pos.xyz) == shadow.pos.xyz) {
		return PCF(shadow, r, dither);
	} else {
		return 0.0;
	}
}

float blockerSearchSimple(vec4 shadowPos) {
	return saturate(shadowPos.z - texture(shadowtex0, shadowPos.xy).x);
}

float blockerSearchPCSS(shadowInfo shadow, int dither) {

	float blocker = 1.0;
	for (int i = dither; i <= 16 + dither; i++) {
		vec2 offs = blue_noise_disk[i] * (20 / shadow.res);
		blocker   = min(blocker, texture(shadowtex0, shadow.pos.xy + offs).x);
	}

	return saturate(shadow.pos.z - blocker);
}

float blockerSearchSmart(shadowInfo shadow, int dither) {

	float blocker = shadow.pos.z + (shadow.bias * 10);
	for (int i = dither; i <= 16 + dither; i++) {
		vec2 offs = blue_noise_disk[i] * (20 / shadow.res);
		blocker   = max(blocker, texture(shadowtex0, shadow.pos.xy + offs).x);
	}

	return saturate(shadow.pos.z - blocker);
}

float shadowPCSS(shadowInfo shadow, float dither) {
	if (shadow.diff > 0.0 && saturate(shadow.pos.xyz) == shadow.pos.xyz) {

		float block  = blockerSearchPCSS(shadow, int(dither * 6));
		float penum  = getPenumbra(block, shadow.res * 2);
		
		return PCF(shadow, penum, dither);

	} else {
		return 0.0;
	}
}