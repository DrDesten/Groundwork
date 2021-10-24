#include "/lib/settings.glsl"
#include "/lib/math.glsl"
//#include "/lib/projection.glsl"
#include "/lib/vertex_transform.glsl"

uniform mat4 gbufferProjection;
uniform mat4 shadowModelView;
uniform mat4 shadowModelViewInverse;
uniform mat4 shadowProjection;
uniform vec3 shadowLightPosition;

#define attribute in
attribute vec4 mc_Entity;

out vec2  lmcoord;
out vec2  coord;
out vec4  glcolor;
out vec3  originalPlayerPos;

float angle(vec2 v) {
    float ang = HALF_PI - atan(v.x / v.y);
    if(v.y < 0) {ang = ang + PI;}
    return ang;
}
vec3 playerToEqui3(vec3 playerPos) {
    float depth     = length(playerPos);
    playerPos       = playerPos / depth; //normalize

    float lambda = angle(playerPos.xz) / TWO_PI;
    float theta  = playerPos.y * .5 + .5;

    return vec3(lambda, theta, depth);
}

void main() {
	//gl_Position = ftransform();

	vec4 sViewPos  = gl_ModelViewMatrix * gl_Vertex;
	vec4 playerPos = shadowModelViewInverse * sViewPos;
	playerPos.y -= 1;
	
	vec3 screenPos = playerToEqui3(playerPos.xyz);
	//screenPos.z    = 1 - exp2(-screenPos.z);
	screenPos.z    = 1 - pow(1.02, -screenPos.z);

	gl_Position       = vec4(screenPos * 2 - 1, 1);
	originalPlayerPos = playerPos.xyz;

	coord      = getCoord();
	lmcoord    = getLmCoord();
	glcolor    = gl_Color;
}