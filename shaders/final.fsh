#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"

uniform sampler2D shadowcolor0;

in vec2 coord;

/* DRAWBUFFERS:0 */
void main() {
    vec3 color = getColor(coord);
    //color = texture(shadowcolor0, coord).rgb;

    color = gamma_inv(color);

    //color = texture(colortex1, coord).rgb * .5 + .5; // Normal Test

    gl_FragColor = vec4(color, 1.0);
}