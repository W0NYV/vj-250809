#pragma once

uniform vec4 resolution;
uniform float time;
uniform float beat;

uniform float sliders[32];
uniform vec4 buttons[32];

vec3 hash(vec3 v) {
    uvec3 r = floatBitsToUint(v);
    r = r * 1664525u + 1013904223u;

    r.x += r.y*r.z;
    r.y += r.z*r.x;
    r.z += r.x*r.y;

    r ^= r >> 16u;

    r.x += r.y*r.z;
    r.y += r.z*r.x;
    r.z += r.x*r.y;

    return vec3(r) / float(0xffffffffu);
}

float easeInExpo(float r, float x) {
    return x == 0.0 ? 0.0 : pow(r, 10.0 * x - 10.0);
}

float easeOutExpo(float x) {
    return x == 1.0 ? 1.0 : 1.0 - pow(2.0, - 10.0 * x);
}