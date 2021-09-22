#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/vertex_transform_simple.glsl"

varying vec4 glcolor; // Stars

void main() {
	gl_Position = ftransform();
	
    glcolor = gl_Color;
}