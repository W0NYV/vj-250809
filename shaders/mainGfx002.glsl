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

float m022() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    uv.y -= 0.175;

    vec2 fp = vec2(fract(uv.x*7.0), fract(uv.y*3.7));

    float offset = hash(vec3(floor(uv.x*7.0), floor(uv.y*3.7), 341.23)).r * 2.0;

    return eye(fp, beat, offset);
}

float m023() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    uv.y += beat/16.0;
    uv.y *= resolution.y/resolution.x;

    Subdiv subdiv = subdivision(fract(uv*7.0*0.25));
    
    float f = 0.0;
    
    float rnd = hash(vec3(floor(beat), subdiv.id)).r;

    vec2 p = subdiv.uv;

    p -= 0.5;
    p *= rot(acos(-1.0)/2.0*floor(rnd*2.0));
    p += 0.5;

    float c0 = step(length(p), 2.0/3.0) + step(length(p-vec2(1.0,1.0)), 2.0/3.0);
    float c1 = step(length(p), 1.0/3.0) + step(length(p-vec2(1.0,1.0)), 1.0/3.0);
    float c2 = step(length(p), 1.0/6.0) + step(length(p-vec2(1.0,1.0)), 1.0/6.0);
    float c2i = step(length(p-vec2(1.0, 0.0)), 1.0/6.0) + step(length(p-vec2(0.0,1.0)), 1.0/6.0);
    float c3 = step(length(p), 1.0/12.0) + step(length(p-vec2(1.0,1.0)), 1.0/12.0);
    float c3i = step(length(p-vec2(1.0, 0.0)), 1.0/12.0) + step(length(p-vec2(0.0,1.0)), 1.0/12.0);
    float c3r = step(length(p-vec2(0.5, 0.0)), 1.0/12.0) + step(length(p-vec2(0.5,1.0)), 1.0/12.0);
    float c3ri = step(length(p-vec2(0.0, 0.5)), 1.0/12.0) + step(length(p-vec2(1.0,0.5)), 1.0/12.0);

    if (subdiv.count == 1) {
        f = (c0 - c1) + (c2 + c2i) - (c3 + c3i + c3r + c3ri);
    } else if (subdiv.count == 2) {
        f = 1.0 - (c2 + c2i + c0 - c1);
    } else if (subdiv.count == 3 || subdiv.count == 4) {
        f = c0 - c1;
    }


    return f;
}

float m024() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    float aspect = resolution.y/resolution.x;
    vec2 fp = vec2(fract(uv.x*7.0), uv.y);

    fp += cyclic(vec3(fp + floor(uv.x*7.0), beat), 10.0).xy * 0.2;
    fp *= rot(acos(-1.0)/7.0*floor(uv.x*7.0)+beat/16.0);

    float f = step(fract(fp.x * 2.0 + beat / 2.0), 0.075) + step(fract(fp.y * 7.0 * aspect), 0.075);

    return clamp(f, 0.0, 1.0);
}

float m025() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    uv.y *= resolution.y/resolution.x;
    uv.x -= beat / 32.0;
    vec2 fp = fract(skew2(uv * 7.0));
    vec2 ip = floor(skew2(uv * 7.0));
    float isUp = fp.x > fp.y ? 1.0 : 0.0;

    float r = hash(vec3(ip + isUp, floor(beat))).x;
    float rNext = hash(vec3(ip + isUp, floor(beat+1.0))).x;

    return clamp(pow(mix(r, rNext, easeInExpo(2.0, fract(beat))), 4.0), 0.0, 1.0);
}

float m026(vec2 p) {
    p.y -= 0.925;

    float f = 0.0;

    for (float i = 0.0; i <= 10.0; i += 0.5) {
        f += step(sdBox(p + vec2(sin(beat / 2.0 + acos(-1.0)/5.0*i) * 1.67, (i/10.0)*1.5), vec2(0.1, 0.02)), 0.0);
        f += step(length(p + vec2(sin(-beat / 2.0 - acos(-1.0)/5.0*i) * 1.67, (i/10.0)*1.5)), 0.05);
    }

    return f;

}

float m027() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec2 fp = vec2(fract(uv.x*7.0), uv.y);
    vec2 ip = vec2(floor(uv.x*7.0), uv.y);

    vec3 rnd = hash(vec3(ip.x, 31.21, floor(beat/2.0)));
    vec3 rndNext = hash(vec3(ip.x, 31.21, floor(beat/2.0)+1.0));
    rnd = mix(rnd, rndNext, easeOutExpo(fract(beat/2.0)));
    float t = floor(beat)+easeInExpo(2.0, fract(beat));
    return sin(sin(fp.x*5.0+beat)+fp.x*2.0+2.0*beat+t+cos(fp.y*4.0+fp.x*3.0*rnd.x+rnd.y*acos(-1.0)*2.0)*10.0+rnd.z*acos(-1.0)*2.0);
}

float m028() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec2 ip = vec2(floor(uv.x*7.0), uv.y);

    return sin(beat/2.0 + acos(-1.0)/7.0*ip.x)*0.5+0.5;
}

float m029() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    fp.y -= 0.085;

    float f = 0.0;

    float offset = floor(hash(vec3(floor(uv.x*7.0), 23.12, floor(beat/2.0))).r * 5.0);

    f += mod(floor(offset + beat*4.0), 5.0) == 0.0 ? step(sdBox(fp, vec2(0.4, 0.4)), 0.0) - step(sdBox(fp, vec2(0.35, 0.385)), 0.0) : 0.0;
    f += mod(floor(offset + beat*4.0), 5.0) == 1.0 ? step(sdBox(fp, vec2(0.3, 0.365)), 0.0) - step(sdBox(fp, vec2(0.25, 0.355)), 0.0) : 0.0; 
    f += mod(floor(offset + beat*4.0), 5.0) == 2.0 ? step(sdBox(fp, vec2(0.2, 0.335)), 0.0) - step(sdBox(fp, vec2(0.15, 0.325)), 0.0) : 0.0;
    f += mod(floor(offset + beat*4.0), 5.0) == 3.0 ? step(sdBox(fp, vec2(0.1, 0.305)), 0.0) - step(sdBox(fp, vec2(0.05, 0.295)), 0.0) : 0.0;
    f += mod(floor(offset + beat*4.0), 5.0) == 4.0 ? step(sdBox(fp, vec2(0.0125, 0.285)), 0.0) : 0.0;

    return f;
}

float m030() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    float aspect = resolution.y/resolution.x;

    float offset = hash(vec3(floor(uv.x*49.0), floor(beat/4.0), 12.12)).r;
    uv.y += (offset - 0.5) * (floor(beat) + easeOutExpo(fract(beat))) + (offset - 0.5) * beat * 0.25;

    vec2 ip = vec2(floor(uv.x*49.0), floor(uv.y*14.0*aspect));

    float f = step(hash(vec3(ip, 31.21)).r, 0.2);

    return f;
}

float m031() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    vec2 fp = vec2(fract(uv.x*7.0), uv.y) - 0.5;
    fp.y -= 0.085;

    float s = hash(vec3(floor(uv.x*7.0), floor(beat), 231.12)).r;
    float sNext = hash(vec3(floor(uv.x*7.0), floor(beat)+1.0, 231.12)).r;
    s = mix(s, sNext, easeOutExpo(fract(beat))) * 0.45 + sin(beat/4.0) * 0.1;

    return step(sdBox(fp, vec2(0.5, s)), 0.0);
}

float m032() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    uv.y += beat/8.0;

    vec2 ip = vec2(floor(uv.x*7.0), floor(uv.y*90.0));

    float r = hash(vec3(ip, floor(beat))).r;
    float rNext = hash(vec3(ip, floor(beat)+1.0)).r;
    r = mix(r, rNext, easeOutElastic(fract(beat)));

    return pow(r, 6.0);

}

