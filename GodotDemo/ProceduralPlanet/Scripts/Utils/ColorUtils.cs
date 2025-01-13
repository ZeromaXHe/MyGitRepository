using Godot;

namespace ProceduralPlanet.Scripts.Utils;

public static class ColorUtils
{
    public static Color RandomColor(RandomNumberGenerator rng,
        float satMin, float satMax, float valMin, float valMax) =>
        Color.FromHsv(rng.Randf(), rng.RandfRange(satMin, satMax), rng.RandfRange(valMin, valMax));

    public static Color TweakHsv(Color color, float deltaH, float deltaS, float deltaV) =>
        Color.FromHsv((color.H + deltaH) % 1f, color.S + deltaS, color.V + deltaV);
}