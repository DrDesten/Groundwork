#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform.glsl"
#include "/lib/shadow_distorsion.glsl"

#define attribute in
attribute vec4 mc_Entity;

out vec2  lmcoord;
out vec2  coord;
out vec4  glcolor;


void main() {

	vec4 clipPos = ftransform();
	clipPos.xyz  = shadowDistortion(clipPos.xyz);
	gl_Position  = clipPos;

	coord      = getCoord();
	lmcoord    = getLmCoord();
	glcolor    = gl_Color;
}