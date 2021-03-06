#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/kernels.glsl"
#include "/lib/gbuffers_basics.glsl"

#ifdef PBR
#include "/lib/unpackPBR.glsl"
#endif

uniform sampler2D shadowtex0;

in vec2  lmcoord;
in vec2  coord;
in vec3  vertNormal;
in float id;
in vec4  glcolor;
in vec4  shadowPos;

/* DRAWBUFFERS:012 */
void main() {

	vec2 lm = lmcoord;
	if (shadowPos.w > 0.0) {	

		float shadowDepth = texture2D(shadowtex0, shadowPos.xy).x;
		if (shadowPos.z > shadowDepth) {
			lm.y *= 0.5;
		} else {
			lm.y = shadowPos.w * .5 + .5;
		}

	} else {
		lm.y *= shadowPos.w * .5 + .5;
	}

	vec4 color = getColor(coord);
	color.rgb *= glcolor.rgb * glcolor.a;
	color.rgb *= texture(lightmap, lm).rgb;
	color.rgb = gamma(color.rgb);

	FD0 = color; // Color
	FD1 = vec4(vertNormal, 1); // Normal
	FD2 = vec4(codeID(id), vec3(1)); // ID
}