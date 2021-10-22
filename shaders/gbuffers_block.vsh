#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

uniform int   blockEntityId;

out vec2  lmcoord;
out vec2  coord;
out vec3  vertNormal;
out float id;
out vec4  glcolor;

void main() {
	gl_Position = ftransform();
	
	coord      = getCoord();
	lmcoord    = getLmCoord();
	vertNormal = getNormal();
	id         = getID(blockEntityId);
	glcolor    = gl_Color;
}