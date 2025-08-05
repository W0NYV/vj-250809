#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

float m001(vec2 p) {
    float t = floor(beat) + easeOutExpo(fract(beat));

    float c = cyclic(vec3(p * 0.7, beat * 0.3 + t * 0.6), 2.0).r;
    c = 0.9 - abs(c);
    c *= c * c * c;
    
    return c;
}

float m002() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    fp.x *= 0.265;
    fp.y -= 0.085;
    
    float t = easeOutExpo(fract(beat));
    
    float f = step(length(fp), t * 0.1);
    
    return f;
}

float m003(vec2 p) {
    
    p.x += beat / 2.0;
    p.y -= 0.175;
    
    vec2 fp = vec2(fract(p.x*0.75), p.y) - 0.5;
    fp.x += asin(sin(-fp.y * 3.0)) * 0.1;
    
    float f = step(length(fp.x), 0.2);
    
    return f;
}

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float dest = 0.0;
    
    int offset = 16;
    int minIdx = offset;
    for (int i = 0; i < 3; i++)
    {
        if (buttons[i + offset].y < buttons[minIdx].y)
        {
            minIdx = i + offset;
        }
    }
    
    dest = minIdx == offset ? m001(p) : dest;
    dest = minIdx == offset + 1 ? m002() : dest;
    dest = minIdx == offset + 2 ? m003(p) : dest;

    vec3 col = vec3(1.0, 0.4, 0.0) * dest;
    
    color = vec4(col, 1.0);
}