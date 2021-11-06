#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"
#include "/lib/kernels.glsl"

uniform vec2 screenSizeInverse;
uniform float nearInverse;

uniform sampler2D colortex3;

in vec2 coord;


vec4 filterBlur3x3(sampler2D ctex, vec2 coord) {
    vec4 col  = vec4(0);
    for (float x = -0.5; x <= 0.6; x+=1) {
        for (float y = -0.5; y <= 0.6; y+=1) {
            col += texture(ctex, vec2(x,y) * screenSizeInverse + coord);
        }
    }
    return col * 0.25;
}

vec4 filterBlurDepth(sampler2D ctex, sampler2D dtex, vec2 coord) {
    vec4  col   = vec4(0);
    float depth = linearizeDepthf(texture(dtex, coord).x, nearInverse);
    float accu  = 0.0;
    for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
            vec2  offs   = (vec2(x,y) - 2) * screenSizeInverse;
            vec4  sCol   = texture(ctex, coord + offs);
            float sDepth = linearizeDepthf(texture(dtex, coord + offs).x, nearInverse);
            float weight = gaussian_5[x] * gaussian_5[y] * saturate(1 - (depth - sDepth));

            accu += weight;
            col  += sCol * weight;
        }
    }
    return col / accu;
}

/* DRAWBUFFERS:0 */
void main() {
    vec3 color = getColor(coord);

    color *= texture(colortex3, coord).rgb;
    //color *= filterBlur3x3(colortex3, coord).rgb;
    //color *= filterBlurDepth(colortex3, depthtex0, coord).rgb * 0.9 + 0.1;

    FD0 = vec4(color, 1.0);
}