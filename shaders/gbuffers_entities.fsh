#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"

#ifdef PBR
#include "/lib/unpackPBR.glsl"
#endif

uniform vec4 entityColor;

in vec2 lmcoord;
in vec2 coord;
in vec3 vertNormal;
in vec4 glcolor;

/* DRAWBUFFERS:013 */
void main() {
	vec4 color = getColor(coord) * glcolor;
	color.rgb  = mix(color.rgb, entityColor.rgb, entityColor.a);
	color.rgb *= texture(lightmap, lmcoord).rgb;
	color.rgb  = gamma(color.rgb);

	FD0 = color; // Color
	FD1 = vec4(vertNormal, 1); // Normal
	FD2 = vec4(1); // AO
}