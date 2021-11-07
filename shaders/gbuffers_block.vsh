#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform.glsl"
#include "/lib/shadow_full_vertex.glsl"

uniform int   blockEntityId;

out vec2  lmcoord;
out vec2  coord;
out vec3  vertNormal;
out float id;
out vec4  glcolor;
out vec4  shadowPos;

void main() {
	gl_Position = ftransform();

	vec3  normal  = getNormal();
	vec3  viewPos = getView();
	float Ldot    = saturate(dot(normalize(shadowLightPosition), normal) * 1.01 - 0.01);

	if (Ldot > 0.0) {
		vec3 playerPos  = toPlayer(viewPos);
		shadowPos.xyz   = shadowPositionFull(playerPos, Ldot);
	}
	shadowPos.w = Ldot;

	coord      = getCoord();
	lmcoord    = getLmCoord();
	vertNormal = normal;
	id         = getID(blockEntityId);
	glcolor    = gl_Color;
}