#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

attribute vec4 mc_Entity;

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
	id         = getID(mc_Entity);
	glcolor    = gl_Color;
}