#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

void main() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);
    
    float id = floor(uv.x * 7.0);
    
    vec3 rnd = hash(vec3(id * 100.0, 804.53, 523.32));
    vec3 rndBeat = hash(vec3(floor(beat), id * 100.0, 523.32));
    
    vec3 dest = vec3(0.0);
    vec3 col = hsv2rgb(vec3(sliders[3], sliders[2], 1.0));

    int minIdx = 0;
    for (int i = 0; i < 4; i++)
    {
        if (buttons[i].y < buttons[minIdx].y)
        {
            minIdx = i;
        }
    }
    
    if (minIdx == 0)
    {
        dest = vec3(1.0);
    }
    else if (minIdx == 1)
    {
        dest = vec3(step(rndBeat.x, 0.5) * easeInExpo(1.35, fract(-beat)));
    }
    else if(minIdx == 2)
    {
        dest = vec3(sin(beat + acos(-1.0) * 2.0 * rnd.x) * 0.5 + 0.5);
    }
    else if(minIdx == 3)
    {
        dest = vec3(mod(id + floor(beat), 2.0) == 0.0 ? 0.0 : easeInExpo(1.35, fract(-beat)));
    }
    
    color = vec4(dest * col * sliders[1], 1.0);
}