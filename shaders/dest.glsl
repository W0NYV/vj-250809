#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

void main() {
    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    color = vec4(uv, sin(beat), 1.0);
}