#version 440

#pragma include "shaders/mainGfx001.glsl"
#pragma include "shaders/mainGfx002.glsl"

out vec4 color;

void main() {
    
    vec2 p = (gl_FragCoord.xy * 2.0 - resolution.xy) / min(resolution.x, resolution.y);
    float dest = 0.0;
    

    int offset = 16;
    int minIdx = offset;
    for (int i = 0; i < 16; i++)
    {
        if (buttons[i + offset].y < buttons[minIdx].y)
        {
            minIdx = i + offset;
        }
    }
    
    if (sliders[8].x < 1.0) {
        dest = minIdx == offset ? m001(p) : dest;
        dest = minIdx == offset + 1 ? m002() : dest;
        dest = minIdx == offset + 2 ? m003(p) : dest;
        dest = minIdx == offset + 3 ? m004(p) : dest;
        dest = minIdx == offset + 4 ? m005(p) : dest;
        dest = minIdx == offset + 5 ? m006() : dest;
        dest = minIdx == offset + 6 ? m007() : dest;
        dest = minIdx == offset + 7 ? m008(p) : dest;
        dest = minIdx == offset + 8 ? m009(p) : dest;
        dest = minIdx == offset + 9 ? m010() : dest;
        dest = minIdx == offset + 10 ? m011() : dest;
        dest = minIdx == offset + 11 ? m012(p) : dest;
        dest = minIdx == offset + 12 ? m013(p) : dest;
        dest = minIdx == offset + 13 ? m014(p) : dest;
        dest = minIdx == offset + 14 ? m015() : dest;
        dest = minIdx == offset + 15 ? m016() : dest;
    } else {
        dest = minIdx == offset ? m017() : dest;
        dest = minIdx == offset + 1 ? m018(p) : dest;
        dest = minIdx == offset + 2 ? m019(p) : dest;
        dest = minIdx == offset + 3 ? m020() : dest;
        dest = minIdx == offset + 4 ? m021() : dest;
        dest = minIdx == offset + 5 ? m022() : dest;
        dest = minIdx == offset + 6 ? m023() : dest;
        dest = minIdx == offset + 7 ? m024() : dest;
        dest = minIdx == offset + 8 ? m025() : dest;
        dest = minIdx == offset + 9 ? m026(p) : dest;
        dest = minIdx == offset + 10 ? m027() : dest;
        dest = minIdx == offset + 11 ? m028() : dest;
    }

    vec3 col = hsv2rgb(vec3(sliders[6], sliders[5], 1.0)) * dest * sliders[4];
    
    color = vec4(col, 1.0);
}