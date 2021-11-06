#define SHADOW_SCALE 1.0
#define SHADOW_ZSCALE 0.3
#define SHADOW_DISTORSION 0.3

vec3 shadowDistortion(vec3 clipPos) {
	clipPos.xy  *= SHADOW_SCALE;
	clipPos.z   *= SHADOW_ZSCALE;

	clipPos.xy  /= length(clipPos.xy) + SHADOW_DISTORSION;
	return clipPos;
}
vec3 shadowDistortion(vec3 clipPos, float len) {
	clipPos.xy  *= SHADOW_SCALE;
	clipPos.z   *= SHADOW_ZSCALE;

	clipPos.xy  /= len + SHADOW_DISTORSION;
	return clipPos;
}

float shadowDistortionDerivative(float len) {
	return SHADOW_DISTORSION / sq(len + SHADOW_DISTORSION);
}
float shadowDistortionDerivativeInverse(float len) {
	return sq(len + SHADOW_DISTORSION) * (1. / SHADOW_DISTORSION);
}