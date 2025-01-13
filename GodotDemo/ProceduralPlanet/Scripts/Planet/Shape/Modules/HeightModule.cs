using Godot;

namespace ProceduralPlanet.Scripts.Planet.Shape.Modules;

[Tool]
[GlobalClass]
public partial class HeightModule : Resource
{
    public virtual float[] Run(RandomNumberGenerator rng, Vector3[] vertices) => [];
}