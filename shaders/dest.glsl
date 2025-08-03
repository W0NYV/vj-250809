#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D testPatternTex;
uniform sampler2D maskTex;
uniform sampler2D mainTex;
uniform sampler2D lightingTex;

out vec4 color;

void main() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    vec4 testPattern = texture(testPatternTex, uv);
    float mask = texture(maskTex, uv).r;
    vec4 main = texture(mainTex, uv);
    vec4 lighting = texture(lightingTex, uv);
    
    vec4 col = mix(main, lighting, mask);
    
    col = mix(col, testPattern, sliders[0]);
    
    color = col;
}