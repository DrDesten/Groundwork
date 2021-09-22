
/*
const int colortex0Format = RGB16F;      // Color
const int colortex1Format = RGB16_SNORM; // Normals
const int colortex2Format = R8;          // ID
*/

const float sunPathRotation = -40.0;

#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"

varying vec2 coord;

/* DRAWBUFFERS:0 */
void main() {
    vec3 color = texture2D(colortex0, coord).rgb;

    FD0 = vec4(color, 1);
}