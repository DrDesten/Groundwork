#include "/lib/shadow_vertex.glsl"
#include "/lib/shadow_distorsion.glsl"

vec3 shadowPositionFull(vec3 playerPos, float NdotL) {
    vec3 shadowPos = getShadowPos(playerPos);
    float sClipLen = length(shadowPos.xy);

    float bias   = getShadowBias(NdotL) * shadowDistortionDerivativeInverse(sClipLen);
    shadowPos    = shadowDistortion(shadowPos.xyz, sClipLen);
    shadowPos    = shadowPos.xyz * .5 + .5;
    shadowPos.z -= bias;

    return shadowPos;
}
vec3 shadowPositionFull(vec3 playerPos, float NdotL, out float bias) {
    vec3 shadowPos = getShadowPos(playerPos);
    float sClipLen = length(shadowPos.xy);

    bias         = getShadowBias(NdotL) * shadowDistortionDerivativeInverse(sClipLen);
    shadowPos    = shadowDistortion(shadowPos.xyz, sClipLen);
    shadowPos    = shadowPos.xyz * .5 + .5;

    return shadowPos;
}