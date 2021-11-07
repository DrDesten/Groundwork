uniform sampler2D shadowtex0;

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