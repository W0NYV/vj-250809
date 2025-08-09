#pragma once

uniform vec4 resolution;
uniform float time;
uniform float beat;

uniform float sliders[32];
uniform vec4 buttons[32];

mat2 rot(float r) {
    return mat2(cos(r), sin(r), -sin(r), cos(r));
}

mat2 skew(float v) {
    return mat2(1.0, tan(v), 0.0, 1.0);
}

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

vec2 randomNormal(vec2 p) {
    float c = sqrt(-2.0 * log(p.x));
    float r = 2.0 * p.y * acos(-1.0);

    return vec2(c * cos(r), c * sin(r));
}

float getIntensity(vec3 col) {
    return dot(col, vec3(0.299, 0.587, 0.114));
}

float easeInExpo(float r, float x) {
    return x == 0.0 ? 0.0 : pow(r, 10.0 * x - 10.0);
}

float easeOutExpo(float x) {
    return x == 1.0 ? 1.0 : 1.0 - pow(2.0, - 10.0 * x);
}

float easeInElastic(float x) {
    float c4 = acos(-1.0) * 2.0 / 3.0;
    return x == 0.0 
    ? 0.0 : x == 1.0 
    ? 1.0 : -pow(2, 10.0 * x - 10.0) * sin((x * 10.0 - 10.75) * c4);
}

float easeOutElastic(float x) {
    float c4 = (2.0 * acos(-1.0)) / 3.0;
    return x == 0.0 ? 0.0 : x == 1.0 ? 1.0 : pow(2.0, -10.0 * x) * sin((x * 10.0 - 0.75) * c4) + 1.0;
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

vec3[9] mooreNeighborhood(sampler2D tex, vec2 fragCoord, vec2 resolution) {
    vec3 mc = texture(tex, (fragCoord + vec2(0.0, 0.0))/resolution.xy).rgb;
    vec3 mr = texture(tex, (fragCoord + vec2(1.0, 0.0))/resolution.xy).rgb;
    vec3 ml = texture(tex, (fragCoord + vec2(-1.0, 0.0))/resolution.xy).rgb;

    vec3 tc = texture(tex, (fragCoord + vec2(0.0, 1.0))/resolution.xy).rgb;
    vec3 tr = texture(tex, (fragCoord + vec2(1.0, 1.0))/resolution.xy).rgb;
    vec3 tl = texture(tex, (fragCoord + vec2(-1.0, 1.0))/resolution.xy).rgb;

    vec3 bc = texture(tex, (fragCoord + vec2(0.0, -1.0))/resolution.xy).rgb;
    vec3 br = texture(tex, (fragCoord + vec2(1.0, -1.0))/resolution.xy).rgb;
    vec3 bl = texture(tex, (fragCoord + vec2(-1.0, -1.0))/resolution.xy).rgb;

    vec3[9] array;
    array[0] = tl, array[1] = tc, array[2] = tr;
    array[3] = ml, array[4] = mc, array[5] = mr;
    array[6] = bl, array[7] = bc, array[8] = br;

    return array;
}

float sdBox(vec2 p, vec2 b) {
    vec2 d = abs(p)-b;
    return length(max(d,0.0)) + min(max(d.x,d.y),0.0);
}

float sdChamferBox(vec2 p, vec2 b) {
    p = abs(p) - b;
    p.y += 0.3;

    const float k = 1.0-sqrt(2.0);
    if( p.y<0.0 && p.y+p.x*k<0.0 ) return p.x;
    if( p.x<p.y ) return (p.x+p.y)*sqrt(0.5);
    return length(p);
}

float S(float x)
{
    float s = 16.0 / 1920.0;
    return smoothstep(-s, s, x);
}

float eye(vec2 uv, float time, float offset){

    float openDeg = 4.5;

    float PI = acos(-1.0);

    float fsty = fract(uv.y) - 0.5;
    vec2 fst = vec2(uv.x * PI * 2.0 - 0.5 * PI, fsty);
    
    float eyeOpen = (sin(time*2.0 + (acos(-1.0)*2.0*(offset/4.0))) + 1.0) / 2.0;
    eyeOpen = 1.0 - pow(eyeOpen, 3.0);
    
    float col = (sin(fst.x) + 1.)/2.0;
    float col2 = col* eyeOpen + fst.y*openDeg - 0.1;
    col = col* eyeOpen - fst.y*openDeg - 0.1;
    float cs1 = min(col - 0.1, col2- 0.1);
    float cs2 = S(cs1);
    col = S(min(col, col2));
    //col = step(0.1, col);
    vec2 loc = vec2(fract(fst.x/PI/2.0 + PI*2.0) - 0.53,fst.y);
    
    float lloc = length(loc);

    float iris = abs((length(loc)*15.0) - 2.0);
    float iris2 = abs((length(loc)*15.0) - 1.0);
    float iris3 = length(loc)*9.0;
    
    iris *= iris2 * iris3;
    
    return min(col, mix(1.0, S(-iris + 0.15), cs2));
}

struct Subdiv
{
    vec2 id;
    vec2 uv;
    vec2 size;
    int count;
};

Subdiv subdivision(vec2 p) {
    vec2 size = vec2(0.5);
    Subdiv dest;

    for (int i = 0; i < 4; i++) {
        dest.id = (floor(p/size)) * size;
        dest.uv = fract(p/size);

        vec3 hash = hash(vec3(dest.id, floor(beat)));

        if (i != 0 && hash.x < 0.5) {
            break;
        } else {
            size *= 0.5;
            dest.count++;
        }
    }

    dest.size = size;
    return dest;
}

vec2 skew2 (vec2 st) {
    vec2 r = vec2(0.0, 0.0);
    r.x = 1.1547*st.x;
    r.y = st.y+0.5*r.x;
    return r;
}

vec3 pal(float t, vec3 a, vec3 b, vec3 c, vec3 d ) {
    return a + b*cos( 6.28318*(c*t+d) );
}