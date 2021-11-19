#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/kernels.glsl"
#include "/lib/gbuffers_basics.glsl"

uniform vec3 fogColor;
uniform vec3 skyColor;

in vec4 glcolor;

/* DRAWBUFFERS:0 */
void main() {
	#ifdef OVERWORLD
	vec4 color = glcolor;
	#elif defined NETHER
	vec4 color = vec4(fogColor, 1);
	#elif defined END
	vec4 color = vec4(fogColor, 1);
	#endif
	color.rgb  = gamma(color.rgb);

	FD0 = color; // Color
}