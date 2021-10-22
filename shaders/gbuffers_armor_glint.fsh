#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"

in vec2 lmcoord;
in vec2 coord;
in vec4 glcolor;

/* DRAWBUFFERS:0 */
void main() {
	vec4 color = getColor(coord) * glcolor;
	color.rgb  = gamma(color.rgb);

	FD0 = color; // Color
}