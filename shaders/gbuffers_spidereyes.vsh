#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

varying vec2 coord;
varying vec3 vertNormal;
varying vec4 glcolor;

void main() {
	gl_Position = ftransform();
	
	coord      = getCoord();
	vertNormal = getNormal();
	glcolor    = gl_Color;
}