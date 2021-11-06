#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform.glsl"
#include "/lib/shadow_full_vertex.glsl"

attribute vec4 mc_Entity;

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
	float Ldot    = dot(normalize(shadowLightPosition), normal);

	if (Ldot > 0.0) {
		vec3 playerPos  = toPlayer(viewPos);
		shadowPos.xyz   = shadowPositionFull(playerPos, Ldot);
	}
	shadowPos.w = Ldot;
	
	coord      = getCoord();
	lmcoord    = getLmCoord();
	vertNormal = normal;
	id         = getID(mc_Entity);
	glcolor    = gl_Color;
}