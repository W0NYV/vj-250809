#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    
    float t = floor(beat) + easeOutExpo(fract(beat));
    
    float c = cyclic(vec3(p * 0.7, beat * 0.3 + t * 0.6), 2.0).r;
    c = 0.9 - abs(c);
    c *= c * c * c;
    
    color = vec4(c, c, c, 1.0);
}