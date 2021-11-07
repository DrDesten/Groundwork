#define SHADOW_SCALE 1.0
#define SHADOW_ZSCALE 0.3
#define SHADOW_DISTORSION 0.3

vec3 shadowDistortion(vec3 clipPos) {
	clipPos.xy  /= length(clipPos.xy) + SHADOW_DISTORSION;
	clipPos.z   *= SHADOW_ZSCALE;
	clipPos.xy  *= (1 + SHADOW_DISTORSION) * SHADOW_SCALE;
	return clipPos;
}
vec3 shadowDistortion(vec3 clipPos, float len) {
	clipPos.xy  /= len + SHADOW_DISTORSION;
	clipPos.z   *= SHADOW_ZSCALE;
	clipPos.xy  *= (1 + SHADOW_DISTORSION) * SHADOW_SCALE;
	return clipPos;
}

float shadowDistortionDerivative(float len) {
	return ( SHADOW_DISTORSION * (1 + SHADOW_DISTORSION) * SHADOW_SCALE ) / sq(len + SHADOW_DISTORSION) ;
}
float shadowDistortionDerivativeInverse(float len) {
	return sq(len + SHADOW_DISTORSION) * (1. / ( SHADOW_DISTORSION * (1 + SHADOW_DISTORSION) * SHADOW_SCALE ) );
}