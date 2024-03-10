uniform vec2 velocity;
vec4 effect(vec4 col, Image texture, vec2 texturePos, vec2 screenPos)
{
    vec4 t1 = Texel(texture, texturePos);
    vec4 t2 = Texel(texture, texturePos + vec2(0.02, 0.0) * velocity);
    vec4 t3 = Texel(texture, texturePos - vec2(0.0, 0.05) * velocity);

    vec3 aberration = vec3(t1.r, t2.g, t3.b);

    return vec4(aberration + t1.rgb / 2., t1.a + ((t1.r + t2.g + t3.b) / 3.0));
}
