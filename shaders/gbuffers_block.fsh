#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"
#include "/lib/shadow_fragment.glsl"

#ifdef PBR
#include "/lib/unpackPBR.glsl"
#endif

in vec2  lmcoord;
in vec2  coord;
in vec3  vertNormal;
in float id;
in vec4  glcolor;
in vec4  shadowPos;

/* DRAWBUFFERS:0123 */
void main() {

	vec2 lm = lmcoord;
	bool shadow = isShadow(shadowPos.xyz, shadowPos.w);
	if (shadow) {
		lm.y *= 0.5;
	} else {
		lm.y  = shadowPos.w * 0.5 + .5;
	}

	vec4 color = getColor(coord) * glcolor;
	color.rgb *= texture(lightmap, lm).rgb;
	color.rgb  = gamma(color.rgb);

	FD0 = color; // Color
	FD1 = vec4(vertNormal, 1); // Normal
	FD2 = vec4(codeID(id), vec3(1)); // ID
	FD3 = vec4(1); // AO
}