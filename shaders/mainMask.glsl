#version 440

#pragma include "shaders/common.glsl"

out vec4 color;

void main() {

    vec2 uv = (gl_FragCoord.xy / resolution.xy);

    float id = floor(uv.x * 7.0);
    vec3 rnd = hash(vec3(id * 100.0, 63.23, 123.42));
    vec3 rndBeat = hash(vec3(floor(beat), id * 100.0, 86.43));

    vec3 dest = vec3(0.0);
    vec3 col = hsv2rgb(vec3(sliders[3], sliders[2], 1.0));

    int offset = 8;
    
    int minIdx = offset;
    for (int i = 0; i < 8; i++)
    {
        if (buttons[i + offset].y < buttons[minIdx].y)
        {
            minIdx = i + offset;
        }
    }

    if (minIdx == offset)
    {
        dest = vec3(1.0);
    }
    else if (minIdx == offset + 1)
    {
        dest = vec3(step(rndBeat.x, 0.75) * easeInExpo(1.05, fract(-beat)));
    }
    else if(minIdx == offset + 2)
    {
        dest = vec3(sin(beat + acos(-1.0) * 2.0 * rnd.x) * 0.5 + 0.5);
    }
    else if(minIdx == offset + 3)
    {
        dest = vec3(mod(id + floor(beat), 2.0) == 0.0 ? 0.0 : easeInExpo(1.05, fract(-beat)));
    }
    else if(minIdx == offset + 4)
    {
        dest = vec3(sin(4.0*acos(-1.0)*id/7.0 + -beat * 4.0));
    }
    else if(minIdx == offset + 5)
    {
        dest = vec3(sin(acos(-1.0)*id/7.0 + -beat * 5.5));
    }
    else if(minIdx == offset + 6)
    {
        dest = vec3(step(fract(uv.y-beat/2.0), 0.5));
    }
    else if(minIdx == offset + 7)
    {
        dest = vec3(step(abs(sin(length(uv.y-0.5) * 10.0 + beat)), 0.75));
    }

    color = vec4(dest, 1.0);
    
}