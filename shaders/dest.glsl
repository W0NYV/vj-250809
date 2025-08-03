#version 440

#pragma include "shaders/common.glsl"

uniform sampler2D testPatternTex;
uniform sampler2D lightingTex;

out vec4 color;

void main() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    vec4 testPattern = texture(testPatternTex, uv);
    vec4 lightingTex = texture(lightingTex, uv);
    
    vec4 col = lightingTex;
    
    col = mix(col, testPattern, sliders[0]);
    
    color = col;
}