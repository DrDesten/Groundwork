#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"

in vec2  lmcoord;
in vec2  coord;
in vec3  vertNormal;
in float id;
in vec4  glcolor;

/* DRAWBUFFERS:0123 */
void main() {
	vec4 color = getColor(coord);
	color.rgb *= glcolor.rgb;
	color.rgb *= texture(lightmap, lmcoord).rgb;
	color.rgb = gamma(color.rgb);

	FD0 = color; // Color
	FD1 = vec4(vertNormal, 1); // Normal
	FD2 = vec4(codeID(id), vec3(1)); // ID
	FD3 = vec4(glcolor.aaa, 1); // AO
}