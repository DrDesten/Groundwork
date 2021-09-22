#define FD0 gl_FragData[0]
#define FD1 gl_FragData[1]
#define FD2 gl_FragData[2]
#define FD3 gl_FragData[3]
#define FD4 gl_FragData[4]
#define FD5 gl_FragData[5]
#define FD6 gl_FragData[6]
#define FD7 gl_FragData[7]
#define FD8 gl_FragData[8]
#define FD9 gl_FragData[9]

uniform sampler2D texture;   // Color
uniform sampler2D lightmap;  // Lightmap

vec4 getColor(vec2 co) {
    return texture2D(texture, co);
}
vec3 getLightmap(vec2 co) {
    return texture2D(lightmap, co).rgb;
}

float codeID(float id) {
    return id * .00392156862745;
}