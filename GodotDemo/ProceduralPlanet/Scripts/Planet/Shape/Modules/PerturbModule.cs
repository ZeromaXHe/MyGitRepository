using Godot;

namespace ProceduralPlanet.Scripts.Planet.Shape.Modules;

[Tool]
[GlobalClass]
public partial class PerturbModule : Resource
{
    public virtual Vector3[] Run(Vector3[] vertices, float maxPerturbStrength) => [];
}