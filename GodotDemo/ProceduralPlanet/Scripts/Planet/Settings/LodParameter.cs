using System;
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
            var emit = value != _resolution; 
            _resolution = value;
            if (emit) EmitChanged();
        }
    }

    private float _minDistance;

    [Export]
    public float MinDistance
    {
        get => _minDistance;
        set
        {
            var emit = Math.Abs(value - _minDistance) > 0.001f; 
            _minDistance = value;
            if (emit) EmitChanged();
        }
    }
}