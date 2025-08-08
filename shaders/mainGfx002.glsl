#pragma once

#pragma include "shaders/common.glsl"

float m017() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec3 h = vec3(floor(uv * vec2(7.0, 6.0)), floor(beat*2.0));
    return hash(h).r;
}

float m018(vec2 p) {
    float f = 1.0;
    vec2 fp = fract(p * 2.0);
    vec2 ip = floor(p * 2.0);
    
    float t = (floor(beat/2.0)+easeOutElastic(fract(beat/2.0)))*2.0 + beat * 2.0;
    
    for (float x = -1.0; x <= 1.0; x += 1.0) {
        for (float y = -1.0; y <= 1.0; y += 1.0) {

            vec2 n = vec2(x, y);
            vec2 point = cyclic(vec3(n + ip, t), 10.0).xy * 0.5 + 0.5;
            
            vec2 diff = n + point - fp;
            
            f = min(f, length(diff));
        }
    }
    
    return clamp(pow(sin(f * 30.0 + beat), 3.0), 0.0, 1.0);
}

float m019(vec2 p) {
    
    p *= skew(0.7);
    
    float f = 0.0;
    
    p.y += beat / 8.0;
    
    for (float i = 1.0; i <= 10.0; i += 1.0)
    {
        vec2 ip = floor(p * i);
        vec3 rnd = hash(vec3(floor(ip * 2.0), floor(beat)));
        vec3 rnd2 = hash(vec3(ip + rnd.xy * 0.5, floor(beat)));
        f = abs(f - step(rnd.x, 0.95));
    }
    
    return f;
}

float m020() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    float id = floor(uv.x*7.0);
    fp.x *= 0.265;
    fp.y -= 0.085;
    
    float f = 0.0;
    
    for (float i = 0.0; i < 11.0; i += 1.0) {
        vec3 rnd = hash(vec3(i, id, floor(beat)));
        vec3 rndNext = hash(vec3(i, id, floor(beat) + 1.0));
        
        vec3 rndL = mix(rnd, rndNext, easeOutExpo(fract(beat)));
        
        vec2 pos = randomNormal(rndL.xy) * vec2(0.05, 0.15);
        float size = 0.025 + abs(randomNormal(rndL.yz)).x * 0.05;

        float d = step(length(fp - pos), size);
        
        f = abs(f - d);
    }

    return f;
}

float m021() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    uv.y *= 1.8;
    
    vec2 p = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    p.x += 0.5;
    p.y += 0.185;
    
    vec3 rnd = hash(vec3(74.31, 3423.32, floor(beat)));

    vec2 ip = floor(p * 2.0) - 0.5;

    float factor = rnd.z < 0.5 ? 1.0 : -1.0;

    if (mod(floor(beat), 2.0) == 1.0) {
        p.x -= floor(rnd.x * 4.0) - 2.0 != ip.y + 0.5 ? factor * easeOutExpo(fract(beat)) / 2.0 : 0.0;
    }
    else
    {
        p.y -= floor(rnd.x * 4.0) - 2.0 != ip.x + 0.5 ? factor * easeOutExpo(fract(beat)) / 2.0 : 0.0;
    }

    vec2 fp = fract(p * 2.0) - 0.5;

    if (mod(floor(beat), 2.0) == 1.0) {
        fp *= floor(rnd.x * 4.0) - 2.0 == ip.y + 0.5 ? rot(easeOutExpo(fract(beat)) * acos(-1.0) / 2.0 * factor) : mat2(1.0, 0.0, 0.0, 1.0);
    }
    else
    {
        fp *= floor(rnd.x * 4.0) - 2.0 == ip.x + 0.5 ? rot(easeOutExpo(fract(beat)) * acos(-1.0) / 2.0 * factor) : mat2(1.0, 0.0, 0.0, 1.0);
    }

    fp *= rot(acos(-1.0) / 4.0);
    return clamp(step(sdBox(fp, vec2(0.06, 0.4)), 0.0001) + step(sdBox(fp, vec2(0.4, 0.06)), 0.0001), 0.0, 1.0);
}

// 目、マルチタイルとるシェっと