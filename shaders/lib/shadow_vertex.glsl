uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

float getShadowBias(float NdotL) {
	return clamp(( sqrt(NdotL * -NdotL + 1) / NdotL ) * (SHADOW_BIAS / shadowMapResolution), 1e-6, 1e6);
}

vec3 getShadowPos(vec3 playerPos) {
	vec3 shadowView = transformMAD(playerPos, shadowModelView);
	vec3 shadowClip = projectOrthographicMAD(shadowView, shadowProjection);
	return shadowClip;
}