#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D logoTex;

out vec4 color;

float sobel() {
    vec3[9] cols = mooreNeighborhood(logoTex, gl_FragCoord.xy, resolution.xy);

    float h = getIntensity(cols[2])
            + getIntensity(cols[5])*2.0
            + getIntensity(cols[8])
            - getIntensity(cols[0])
            - getIntensity(cols[3])*2.0
            - getIntensity(cols[6]);

    float v = getIntensity(cols[6])
            + getIntensity(cols[7])*2.0
            + getIntensity(cols[8])
            - getIntensity(cols[0])
            - getIntensity(cols[1])*2.0
            - getIntensity(cols[2]);
    
    return length(vec2(h,v));
}

void main() {
    
    float edge = sobel();
    
    color = vec4(edge, edge, edge, 1.0);
}