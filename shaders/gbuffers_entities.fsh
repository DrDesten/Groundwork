#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"

uniform vec4 entityColor;

varying vec2 lmcoord;
varying vec2 coord;
varying vec3 vertNormal;
varying vec4 glcolor;

/* DRAWBUFFERS:01 */
void main() {
	vec4 color = texture2D(texture, coord, 0) * glcolor;
	color.rgb  = mix(color.rgb, entityColor.rgb, entityColor.a);
	color.rgb *= texture2D(lightmap, lmcoord).rgb;
	color.rgb  = gamma(color.rgb);

	FD0 = color; // Color
	FD1 = vec4(vertNormal, 1); // Normal
}