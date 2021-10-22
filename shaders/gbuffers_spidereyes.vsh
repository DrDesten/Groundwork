#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

out vec2 coord;
out vec3 vertNormal;
out vec4 glcolor;

void main() {
	gl_Position = ftransform();
	
	coord      = getCoord();
	vertNormal = getNormal();
	glcolor    = gl_Color;
}