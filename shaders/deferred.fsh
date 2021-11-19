#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/kernels.glsl"
#include "/lib/composite_basics.glsl"
#include "/lib/transform.glsl"

uniform vec2  screenSize;
uniform float nearInverse;

uniform sampler2D colortex3;
uniform sampler2D noisetex;

in vec2 coord;

float distanceAttenuation(float x, float maxval) {
    return sq( (x - maxval) / maxval );
}

float SimpleSSAO(vec2 coord, float radius, float dither) {
    float depth  = getDepth(coord);
    float ldepth = linearizeDepthf(depth, nearInverse);
    vec3  normal = getNormal(coord);

    radius /= length(toView(vec3(coord, depth) * 2 - 1)) * 8;
    radius *= fovScale;

    float ao = 0.0;
    float norm = 0.0;
    float s = 0.25 + dither;
    for (int i = 0; i < 4; i++) {

        s += 0.5 + dither;
        vec2  offs = spiralOffset(s, 8) * radius;
        float s1   = linearizeDepthf(getDepth(coord + offs), nearInverse);
        float s2   = linearizeDepthf(getDepth(coord - offs), nearInverse);

        float attenuation = saturate(distanceAttenuation(i * radius, 8 * radius));
        ao   += saturate( (ldepth - s1) + (ldepth - s2) ) * attenuation;
        norm += attenuation;

    }

    return sq(1 - (ao / norm));
}

/* DRAWBUFFERS:3 */
void main() {
    vec3 lighting = texture(colortex3, coord).rgb;

    //lighting *= vec3(SimpleSSAO(coord, .5, texture(noisetex, coord * (screenSize / 64)).x * 0.1));// * 0.5 + 0.5;

    FD0 = vec4(lighting, 1.0);
}