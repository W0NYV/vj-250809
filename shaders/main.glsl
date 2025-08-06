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

float m004(vec2 p) {
    float dest = 0.0;
    
    p *= rot(beat/16.0);
    
    for (int i = 0; i < 64; i++) {
        vec3 rnd = hash(vec3(i, floor(beat*2.0), 423.3));
        
        vec2 p2 = p;
        
        p2 *= rot(acos(-1.0) * rnd.z);
        p2.x += (rnd.x * 2.0 - 1.0) * 2.0;
        p2.y += rnd.y * 2.0 - 1.0;
        
        float d = sdBox(p2, vec2(0.01, 0.7));
        
        dest += step(d, 0.0);
    }
    
    return min(dest, 1.0);
}

float m005(vec2 p)
{
    float c = 0.0;
    vec2 reso = vec2(160.0, 90.0);
    vec2 p2 = p;
    vec3 rnd = hash(vec3(floor(beat), 64.3, 123.12));

    for (float i = 0.0; i < 8.0; i += 1.0)
    {
        vec3 rnd2 = hash(vec3(435.23, floor(beat), i));
        vec3 n = cyclic(vec3(p.x * 1.2 + i * 0.5, beat / 2.0, (floor(beat) + easeOutExpo(fract(beat))) * 2.0), 10.0);

        float circle = step(abs(length(floor((p2 - (rnd2.xy * 2.0 - 1.0) * vec2(2.0, 1.0)) * reso) / reso) - 0.2 - rnd2.z * 0.2), 0.01);
        c += circle;

        p *= rot(acos(-1.0) * (rnd.x * 2.0 - 1.0) * 0.15);

        c += step(length((floor(p.y*reso)/reso) + n.x * 0.3), 0.02);
    }
    
    return c;
}

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float dest = 0.0;
    
    int offset = 16;
    int minIdx = offset;
    for (int i = 0; i < 5; i++)
    {
        if (buttons[i + offset].y < buttons[minIdx].y)
        {
            minIdx = i + offset;
        }
    }
    
    dest = minIdx == offset ? m001(p) : dest;
    dest = minIdx == offset + 1 ? m002() : dest;
    dest = minIdx == offset + 2 ? m003(p) : dest;
    dest = minIdx == offset + 3 ? m004(p) : dest;
    dest = minIdx == offset + 4 ? m005(p) : dest;

    vec3 col = vec3(0.1, 0.8, 1.0) * dest;
    
    color = vec4(col, 1.0);
}