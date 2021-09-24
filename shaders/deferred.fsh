#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"
#include "/lib/transform.glsl"

uniform vec2  screenSize;
uniform float nearInverse;

varying vec2 coord;

float distanceAttenuation(float x, float maxval) {
    return 1 - sq(x / maxval);
}
float distanceAttenuation2(float x, float maxval) {
    return sq( (x - maxval) / maxval );
}

// Spins A point around the origin (negate for full coverage)
vec2 spiralOffset(float x, float expansion) {
    float n = fract(x * expansion) * PI;
    return vec2(cos(n), sin(n)) * x;
}


float SimpleSSAO(vec2 coord, float radius, float dither) {
    float depth  = getDepth(coord);
    float ldepth = linearizeDepthf(depth, nearInverse);
    vec3  normal = getNormal(coord);

    radius /= length(toView(vec3(coord, depth) * 2 - 1)) * 8;

    float ao = 0.0;
    for (int i = 0; i < 4; i++) {

        vec2  offs = spiralOffset(i + dither, 8) * radius;
        float s1   = getDepth(coord + offs);
        float s2   = getDepth(coord - offs);

        float attenuation = saturate(distanceAttenuation2(i * radius, 8 * radius));
        ao += saturate( ( (ldepth - linearizeDepthf(s1, nearInverse)) ) + ( (ldepth - linearizeDepthf(s2, nearInverse)) ) ) * attenuation;

    }

    return sq(1 - (ao / 8));
}

/* DRAWBUFFERS:0 */
void main() {
    vec3 color = texture2D(colortex0, coord).rgb;

    color *= vec3(SimpleSSAO(coord, 1, Bayer8(coord * screenSize) * 0.1));// * 0.5 + 0.5;

    FD0 = vec4(color, 1.0);
}