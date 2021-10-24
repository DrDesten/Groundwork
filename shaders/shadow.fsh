#extension GL_EXT_shader_image_load_store : require

#include "/lib/settings.glsl"
#include "/lib/math.glsl"
#include "/lib/gbuffers_basics.glsl"

uniform vec2 screenSizeInverse;

uniform sampler2D shadowcolor0;
uniform sampler2D shadowtex0;
layout (rgba8) uniform image2D shadowcolorimg0;

in vec2  lmcoord;
in vec2  coord;
in vec4  glcolor;
in vec3  originalPlayerPos;

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

/* DRAWBUFFERS:0 */

void main() {
	vec4 color = getColor(coord);
	color.rgb *= glcolor.rgb * glcolor.a;
	color.rgb *= getLightmap(lmcoord);
	color.rgb  = gamma(color.rgb);

	vec3 screenPos = playerToEqui3(originalPlayerPos.xyz);
	vec2 error     = screenPos.xy * shadowMapResolution - gl_FragCoord.xy;
	
	color.a  = step(0.01, color.a); 						// preserve transparent cutout
	color.a *= 1 - pow(1.02, -length(originalPlayerPos));	// Custom depth format

	if (sqmag(error) >= 0.) {
		ivec2 intCoords = ivec2(screenPos.xy * shadowMapResolution + 0.5);

		float prevDepth = min(texelFetch(shadowcolor0, intCoords, 0).a, texelFetch(shadowtex0, intCoords, 0).x);
		if (prevDepth > color.a && color.a != 0) {
			imageStore(shadowcolorimg0, intCoords, color);
		}

		/* if (sqmag(error) > 0.5) {
			color.a = 0;
		} */
	}

	/* ivec2 intCoords = ivec2(gl_FragCoord.xy);
	float prevDepth = texelFetch(shadowcolor0, intCoords, 0).a;
	if (prevDepth > color.a && color.a != 0) {
		imageStore(shadowcolorimg0, intCoords, color);
	} */

	//color.rgb = vec3(length(error) > 1.5 / shadowMapResolution);
	color.a = 0;

	FD0 = color; // FD0 -> gl_FragData[0]
}