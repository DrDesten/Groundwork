#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

uniform int   blockEntityId;

varying vec2  lmcoord;
varying vec2  coord;
varying vec3  vertNormal;
varying float id;
varying vec4  glcolor;

void main() {
	gl_Position = ftransform();
	
	coord      = getCoord();
	lmcoord    = getLmCoord();
	vertNormal = getNormal();
	id         = getID(blockEntityId);
	glcolor    = gl_Color;
}