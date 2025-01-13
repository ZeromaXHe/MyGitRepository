using Godot;
using ProceduralPlanet.Scripts.Planet;

namespace ProceduralPlanet.Scripts.Effects.PostProcessing;

[Tool]
public partial class PlanetEffectHolder : Node
{
    public OceanEffect OceanEffect;
    public AtmosphereEffect AtmosphereEffect;
    public CelestialBodyGenerator Generator;

    public PlanetEffectHolder()
    {
    }

    public PlanetEffectHolder(CelestialBodyGenerator generator, Node3D light)
    {
        Generator = generator;
        if ((Generator?.Body?.Shading?.HasOcean ?? false) && Generator.Body.Shading.OceanSettings != null)
            OceanEffect = new OceanEffect(light);
        if ((Generator?.Body?.Shading?.HasAtmosphere ?? false) && Generator.Body.Shading.AtmosphereSettings != null)
            AtmosphereEffect = new AtmosphereEffect(light);
    }

    public float DistFromSurface(Vector3 viewPos) =>
        Mathf.Max(0f, (Generator.GlobalPosition - viewPos).Length() - Generator.BodyScale());
}