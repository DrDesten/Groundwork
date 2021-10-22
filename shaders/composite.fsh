
/*
const int colortex0Format = RGB16F;      // Color
const int colortex1Format = RGB16_SNORM; // Normals
const int colortex2Format = R8;          // ID

const int colortex3Format = RGB16F       // Lighting



const int shadowcolor0Format = RGBA8       // Shadow
*/

const vec4 colortex3ClearColor = vec4(1,1,1,1);  // Lighting

const float sunPathRotation = -40.0;

const int noiseTextureResolution = 64; 

#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/composite_basics.glsl"

in vec2 coord;



/* DRAWBUFFERS:0 */
void main() {
    vec3 color = getColor(coord);

    FD0 = vec4(color, 1);
}