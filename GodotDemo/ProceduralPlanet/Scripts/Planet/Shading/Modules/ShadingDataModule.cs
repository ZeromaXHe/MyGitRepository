using Godot;

namespace ProceduralPlanet.Scripts.Planet.Shading.Modules;

[Tool]
[GlobalClass]
public partial class ShadingDataModule : Resource
{
    public virtual Vector2[][] Run(RandomNumberGenerator rng, Vector3[] vertices) => [];
}