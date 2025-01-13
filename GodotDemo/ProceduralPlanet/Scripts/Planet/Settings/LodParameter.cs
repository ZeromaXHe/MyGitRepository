using Godot;

namespace ProceduralPlanet.Scripts.Planet.Settings;

[Tool]
[GlobalClass]
public partial class LodParameter : Resource
{
    private int _resolution;

    [Export]
    public int Resolution
    {
        get => _resolution;
        set
        {
            _resolution = value;
            EmitChanged();
        }
    }

    private float _minDistance;

    [Export]
    public float MinDistance
    {
        get => _minDistance;
        set
        {
            _minDistance = value;
            EmitChanged();
        }
    }
}