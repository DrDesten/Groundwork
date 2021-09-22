#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"

varying vec2 coord;

/* DRAWBUFFERS:0 */
void main() {
    vec3 color = texture2D(colortex0, coord).rgb;

    FD0 = vec4(color, 1.0);
}