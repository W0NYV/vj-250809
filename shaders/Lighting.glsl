#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

void main() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    float id = floor(uv.x * 7.0);
    
    uv.x = fract(uv.x * 7.0);


    vec3 rnd = hash(vec3(id * 100.0, 804.53, 523.32));
    vec3 rndBeat = hash(vec3(floor(beat), id * 100.0, 523.32));
    
    vec3 col = vec3(0.0);

    int minIdx = 0;
    for (int i = 0; i < 2; i++)
    {
        if (buttons[i].y < buttons[minIdx].y)
        {
            minIdx = i;
        }
    }
    
    if (minIdx == 0)
    {
        col = vec3(step(rndBeat.x, 0.5) * easeInExpo(1.35, fract(-beat)));
    }
    else if(minIdx == 1)
    {
        col = vec3(sin(beat + acos(-1.0) * 2.0 * rnd.x) * 0.5 + 0.5);
    }
    
    color = vec4(col * sliders[1], 1.0);
}