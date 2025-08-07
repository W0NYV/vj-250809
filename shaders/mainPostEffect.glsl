#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D mainTex;
uniform sampler2D sobelTex;


out vec4 color;

float edge(vec2 uv)
{
    uv.x += 0.5;
    uv.y -= 0.585;
    vec2 fp = vec2(fract(uv.x * 7.0), fract(uv.y*1.2)) - 0.5;
    
    return clamp(step(length(fp.x), 0.04*0.75) + step(length(fp.y), 0.01), 0.0, 1.0);
}

void main() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    vec3 noise = cyclic(vec3(uv * 3.0, floor(beat*8.0)), 2.0);

    vec4 main = texture(mainTex, uv);
    vec4 sobel = texture(sobelTex, uv + noise.xy * 0.015);
    vec4 edge = vec4(edge(uv)) * abs(sin(beat*acos(-1.0)/8.0));
    
    color = main + sobel + edge;
}