#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D mainTex;
uniform sampler2D sobelTex;


out vec4 color;

void main() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    vec3 noise = cyclic(vec3(uv * 3.0, floor(beat*8.0)), 2.0);

    vec4 main = texture(mainTex, uv);
    vec4 sobel = texture(sobelTex, uv + noise.xy * 0.015);

    color = main + sobel;
}