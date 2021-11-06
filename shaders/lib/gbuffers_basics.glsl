layout(location = 0) out vec4 FD0;
layout(location = 1) out vec4 FD1;
layout(location = 2) out vec4 FD2;
layout(location = 3) out vec4 FD3;
layout(location = 4) out vec4 FD4;
layout(location = 5) out vec4 FD5;
layout(location = 6) out vec4 FD6;
layout(location = 7) out vec4 FD7;
layout(location = 8) out vec4 FD8;
layout(location = 9) out vec4 FD9;

uniform sampler2D gtexture;  // Color
uniform sampler2D lightmap;  // Lightmap

vec4 getColor(vec2 co) {
    return texture(gtexture, co);
}
vec3 getLightmap(vec2 co) {
    return texture(lightmap, co).rgb;
}

void getLmDir(in vec2 co, out vec2 skyLight, out vec2 blockLight) {
    blockLight = -vec2(dFdx(co.x), dFdy(co.x));
    blockLight = abs(blockLight.x) + abs(blockLight.y) < 1e-6 ? blockLight : normalize(blockLight);
    skyLight   = -vec2(dFdx(co.y), dFdy(co.y));
    skyLight   = abs(skyLight.x)   + abs(skyLight.y)   < 1e-6 ? skyLight   : normalize(skyLight);
}

float codeID(float id) {
    return id * .00392156862745; // Equivalent to 'return id/255'
}