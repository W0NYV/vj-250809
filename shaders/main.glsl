#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

float m001(vec2 p) {
    float t = floor(beat) + easeOutExpo(fract(beat));
    float c = cyclic(vec3(p * 0.7, beat * 0.3 + t * 0.6), 2.0).r;
    c = 0.9 - abs(c);
    c *= c * c * c;
    c *= 1.35;
    return c;
}

float m002() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    fp.x *= 0.265;
    fp.y -= 0.085;
    
    float t = easeOutExpo(fract(beat));
    
    float f = step(length(fp), 0.065 + t * 0.035);
    
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

float m005(vec2 p) {
    return clamp(pow(abs(sin(-p.y - beat / 2.0)), 5.0) + 0.1, 0.0, 1.0);
}

float m006() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    float aspect = resolution.y/resolution.x;
    
    vec3 s = hash(vec3(floor(uv.x*7.0), 342.23, 65.45));
    uv.y += beat / 8.0 * (0.8 + s.y * 0.2) + s.x;

    vec2 ip = floor(uv*vec2(7.0, 7.0 * aspect)) - 0.5;
    vec2 fp = fract(uv*vec2(7.0, 7.0 * aspect)) - 0.5;
    vec3 rnd = hash(vec3(ip, 431.21));
    vec3 rndBeat = hash(vec3(ip, floor(beat)));

    float dest = 0.0;

    if (rnd.x < 0.25) {
        vec2 p2 = fp;
        p2 *= rot(acos(-1.0)/4.0);
        p2.x += beat * 0.1;
        dest = step(sin(p2.x*40.0), 0.0) * step(sdBox(fp, vec2(0.35)), 0.0);
    } else if (rnd.x < 0.5) {
        vec2 p2 = fp;
        float time = easeOutExpo(fract(beat))*0.375;
        p2 *= rot(acos(-1.0)/-4.0);
        float f = step(sdChamferBox(p2, vec2(0.4)), 0.0);
        float ff = step(sdChamferBox(p2, vec2(time)), 0.0);
        dest = f - ff;
    } else if (rnd.x < 0.75) {
        vec2 p2 = fp;
        p2 *= rot(acos(-1.0)/4.0);
        p2 *= rot(acos(-1.0)/4.0 * 2.0 * floor(rndBeat.x*4.0));
        vec2 p3 = p2;
        p2.y += 0.4;
        p2.x = abs(p2.x);
        p2 *= rot(acos(-1.0)/4.0) * skew(acos(-1.0)/-4.0);
        p2.x -= 0.15;
        float f = step(sdBox(p2, vec2(0.4, 0.1)), 0.0);
        f += step(sdBox(p3, vec2(0.125, 0.35)), 0.0);
        dest = min(1.0, f);
    }
    
    return dest;
}

float m007() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    float aspect = resolution.y/resolution.x;

    uv.y *= 7.0 * aspect;
    uv.y -= sin(beat / 2.0 + floor(uv.x*7.0)/7.0*acos(-1.0)*2.0) + 1.8;
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;

    float dist = abs(fp.x)+abs(fp.y);
    
    return pow(sin(sdBox(fp, vec2(1.0)) * 10.0 - beat * 4.0), 3.0) * step((length(fp.x)), 0.4);
}

float m008(vec2 p) {
    float o = floor(gl_FragCoord.x / resolution.x * 7.0)/7.0 * acos(-1.0) * 2.0;
    return clamp(pow(abs(sin(-p.y - beat / 2.0 + o)), 8.0) + 0.1, 0.0, 1.0);
}

float m009(vec2 p) {
    
    float t = floor(beat) + easeOutElastic(fract(beat));
    
    float cx = cyclic(vec3(p * 0.5, t * 0.45), 2.0).r;
    float cy = cyclic(vec3(p.y, t * 0.45, p.x * 2.0), 2.0).r;
    
    vec2 p2 = vec2(cx, cy);
    p2 *= rot(-beat * 0.2);

    float c = cyclic(vec3(p2.y * 10.0, t * 0.3, p2.x * 10.0), 10.0).x;
    
    return pow(sin(c * 2.0), 3.0);
}

float m010() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    vec2 fp = vec2(fract(uv.x * 7.0), uv.y) - 0.5;
    float f = 0.0;
    
    for (float i = -0.2; i <= 0.2; i += 0.2)
    {
        vec2 p2 = fp;
        p2.x += cyclic(vec3(p2.y, floor(uv.x*7.0)-0.5 + i, floor(beat*8.0)), 1.5).r * 0.2;
        f += step(length(p2.x - i), 0.02);
    }
    
    return min(f, 1.0);
}

float m011() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    return sin(acos(-1.0) * uv.x * 7.0 -  beat * acos(-1.0));
}

float m012(vec2 p) {
    p *= 0.3;
    
    float c = sin(p.x * 5.0);
    c += sin((p.y * 10.0 + beat)/2.0);
    c += sin((p.x * 2.0 + p.y * 20.0)/2.0);
    c = sin(c * 5.0 + beat * 2.0);
    c += cos(p.x*10.0)*sin(p.x*10.0 + beat);
    c = cos(c * 3.0 + beat * 2.0 + p.y * 20.0);
    
    return c;
}

float m013(vec2 p) {
    
    float f = 0.0;
    
    for (float i = 1.0; i < 6.0; i += 1.0) {
        
        vec2 p2 = p;
        p2.x += beat / i * 0.25;
        p2 = fract(p2 * i * 3.5 / 2.0) - 0.5;
        
        f += 0.02 / length(p2);
        f /= i * 0.3;
    }
    
    return min(pow(f, 2.0), 1.0);
}

float m014(vec2 p) {
    float bounce = floor(beat) + easeOutExpo(fract(beat));
    vec3 noise = cyclic(vec3(beat/2.0, 324.32, 745.43), 8.0) * 0.5 + vec3(1.0);
    float id = floor(p.x * (0.2 + noise.x * 2.0) + beat / 2.0) - 0.5;
    p.x = fract(p.x * (0.2 + noise.x * 2.0) + beat / 2.0) - 0.5;
    float d = cyclic(vec3(beat / 4.0 + bounce * 0.65, id, 2312.32), 8.0).x;
    float f = length(p.x + asin(sin(bounce * 0.75 + p.y * (2.0 + d * 8.0))) * 0.2);
    f = step(f, 0.01 + 0.1 * (cyclic(vec3(id), 2.0).y * 0.5 + 1.0));
    return f;
}

float m015() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec3 rnd = hash(vec3(floor(uv.x*7.0)-0.5, 4323.2, 125.34));
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    fp.y -= 0.085;
    float t = beat + (floor(uv.x*7.0)-0.5)/(3.5/2.0);
    float d = step(sdBox(fp, vec2(easeInExpo(1.5, fract(t*0.25)))), 0.0);
    d = mod(floor(t), 8.0) > 3.0 ? d : 1.0 - d;
    return d;
}

float m016() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec3 rnd = hash(vec3(floor(uv.x*7.0)-0.5, 4323.2, 125.34));
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    float t = beat + (floor(uv.x*7.0)-0.5)/(7.0/32.0);
    float d = step(sdBox(fp, vec2(easeInElastic(fract(-t/8.0)), 1.0)), 0.0);
    d = mod(floor(-t), 16.0) > 7.0 ? d : 1.0 - d;
    return d;
}

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float dest = 0.0;
    
    int offset = 16;
    int minIdx = offset;
    for (int i = 0; i < 16; i++)
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
    dest = minIdx == offset + 5 ? m006() : dest;
    dest = minIdx == offset + 6 ? m007() : dest;
    dest = minIdx == offset + 7 ? m008(p) : dest;
    dest = minIdx == offset + 8 ? m009(p) : dest;
    dest = minIdx == offset + 9 ? m010() : dest;
    dest = minIdx == offset + 10 ? m011() : dest;
    dest = minIdx == offset + 11 ? m012(p) : dest;
    dest = minIdx == offset + 12 ? m013(p) : dest;
    dest = minIdx == offset + 13 ? m014(p) : dest;
    dest = minIdx == offset + 14 ? m015() : dest;
    dest = minIdx == offset + 15 ? m016() : dest;

    vec3 col = vec3(0.1, 0.4, 1.0) * dest;
    
    color = vec4(col, 1.0);
}