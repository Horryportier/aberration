uniform vec4 modulate;

vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos)
{
    vec4 t = Texel(texture, texturePos);

    float grey = (t.r + t.g + t.b) / 3.0;
    if (grey == 1) {
        return modulate;
    } else {
        return t;
    }
}
