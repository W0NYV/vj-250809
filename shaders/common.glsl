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

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

mat3 orthbas( vec3 z ) {
    z = normalize( z );
    vec3 up = abs( z.y ) < 0.999 ? vec3( 0, 1, 0 ) : vec3( 0, 0, 1 );
    vec3 x = normalize( cross( up, z ) );
    return mat3( x, cross( z, x ), z );
}

vec3 cyclic( vec3 p, float pump ) {
    mat3 b = orthbas( vec3( -3.0, 2.0, -1.0 ) );
    vec4 sum = vec4( 0.0 );

    for( int i = 0; i < 5; i ++ ) {
        p *= b;
        p += sin( p.yzx );
        sum += vec4( cross( cos( p ), sin( p.zxy ) ), 1.0 );
        p *= 2.0;
        sum *= pump;
    }

    return sum.xyz / sum.w;
}