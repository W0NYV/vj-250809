#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D mainTex;
uniform sampler2D sobelTex;
uniform sampler2D logoOutTex;
uniform sampler2D logoTex;


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
    vec3 noise2 = cyclic(vec3(uv.yx * 2.0, floor(beat*4.0)), 2.0);

    vec4 main = texture(mainTex, uv);
    vec4 sobel = texture(sobelTex, uv + noise.xy * 0.015) * sliders[16];
    vec4 edge = vec4(edge(uv)) * abs(sin(beat*acos(-1.0)/4.0)) * sliders[17];

    float luma = getIntensity(texture(logoTex, uv).rgb);
    vec4 logo = vec4(luma, luma, luma, 1.0);
    logo += texture(logoOutTex, vec2(1.0/7.0*3.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo += texture(logoOutTex, vec2(1.0/7.0*2.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo += texture(logoOutTex, vec2(1.0/7.0*1.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo += texture(logoOutTex, vec2(1.0/7.0*-1.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo += texture(logoOutTex, vec2(1.0/7.0*-2.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo += texture(logoOutTex, vec2(1.0/7.0*-3.0, 0.0) + uv + noise.zx * vec2(0.0,0.01));
    logo *= sliders[0].x;

    vec4 lamp = vec4(pal(noise2.x, vec3(0.5,0.5,0.5),vec3(0.5,0.5,0.5),vec3(1.0,1.0,1.0),vec3(0.0,0.33,0.67) ), 1.0);
    vec4 lamp2 = vec4(pal( noise2.x, vec3(0.5,0.5,0.5),vec3(0.5,0.5,0.5),vec3(1.0,1.0,0.5),vec3(0.8,0.90,0.30) ), 1.0);

    lamp = mix(lamp, lamp2, sliders[19]);
    lamp = mix(vec4(1.0), lamp, sliders[18]);
    
    color = main * lamp + sobel + edge;

    color = abs(color - logo);

}