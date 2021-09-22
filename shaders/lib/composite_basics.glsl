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

uniform sampler2D colortex0; // Color
uniform sampler2D colortex1; // Normals
uniform sampler2D colortex2; // ID
uniform sampler2D depthtex0; // Depth

vec3 getColor(vec2 co) {
    return texture2D(colortex0, co).rgb;
}
float getDepth(vec2 co) {
    return texture2D(depthtex0, co).x;
}

vec3 getNormal(vec2 co) {
    return texture2D(colortex1, co).xyz;
}
float getID(vec2 co) {
    return floor(texture2D(colortex2, co).x * 255 + 0.5);
}
float codeID(float id) {
    return id * .00392156862745;
}