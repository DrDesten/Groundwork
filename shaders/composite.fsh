
/*
const int colortex0Format = R11F_G11F_B10F; // Color
const int colortex1Format = RGB16_SNORM;    // Normals
const int colortex2Format = R8;             // ID

const int colortex3Format = R11F_G11F_B10F  // Lighting



const int shadowcolor0Format = RGBA8       // Shadow
*/

const vec4 colortex3ClearColor = vec4(1,1,1,1);  // Lighting

const float sunPathRotation = -35.0;
//const bool  shadowcolor0Nearest = true;
//const bool  shadowtex0Nearest = true;
//const bool  shadowtex1Nearest = true;

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