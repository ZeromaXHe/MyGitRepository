using System;
using Godot;

namespace ProceduralPlanet.Scripts.Planet.Settings.NoiseSettings;

[Tool]
[GlobalClass]
public partial class RidgeNoiseSettings : Resource
{
    private int _numLayers = 5;

    [Export]
    public int NumLayers
    {
        get => _numLayers;
        set
        {
            var emit = value != _numLayers;
            _numLayers = value;
            if (emit) EmitChanged();
        }
    }

    private float _lacunarity = 2f;

    [Export]
    public float Lacunarity
    {
        get => _lacunarity;
        set
        {
            var emit = Math.Abs(value - _lacunarity) > 0.001f;
            _lacunarity = value;
            if (emit) EmitChanged();
        }
    }

    private float _persistence = 0.5f;

    [Export]
    public float Persistence
    {
        get => _persistence;
        set
        {
            var emit = Math.Abs(value - _persistence) > 0.001f;
            _persistence = value;
            if (emit) EmitChanged();
        }
    }

    private float _scale = 1f;

    [Export]
    public float Scale
    {
        get => _scale;
        set
        {
            var emit = Math.Abs(value - _scale) > 0.001f;
            _scale = value;
            if (emit) EmitChanged();
        }
    }

    private float _power = 2f;

    [Export]
    public float Power
    {
        get => _power;
        set
        {
            var emit = Math.Abs(value - _power) > 0.001f;
            _power = value;
            if (emit) EmitChanged();
        }
    }

    private float _elevation = 1f;

    [Export]
    public float Elevation
    {
        get => _elevation;
        set
        {
            var emit = Math.Abs(value - _elevation) > 0.001f;
            _elevation = value;
            if (emit) EmitChanged();
        }
    }

    private float _gain = 1f;

    [Export]
    public float Gain
    {
        get => _gain;
        set
        {
            var emit = Math.Abs(value - _gain) > 0.001f;
            _gain = value;
            if (emit) EmitChanged();
        }
    }

    private float _verticalShift = 0f;

    [Export]
    public float VerticalShift
    {
        get => _verticalShift;
        set
        {
            var emit = Math.Abs(value - _verticalShift) > 0.001f;
            _verticalShift = value;
            if (emit) EmitChanged();
        }
    }

    private float _peakSmoothing = 0f;

    [Export]
    public float PeakSmoothing
    {
        get => _peakSmoothing;
        set
        {
            var emit = Math.Abs(value - _peakSmoothing) > 0.001f;
            _peakSmoothing = value;
            if (emit) EmitChanged();
        }
    }

    private Vector3 _offset = Vector3.Zero;

    [Export]
    public Vector3 Offset
    {
        get => _offset;
        set
        {
            var emit = value != _offset;
            _offset = value;
            if (emit) EmitChanged();
        }
    }

    public float[] GetNoiseParams(RandomNumberGenerator rng)
    {
        var seededOffset = new Vector3(rng.Randf(), rng.Randf(), rng.Randf()) * rng.Randf() * 10000f;
        var noiseParams = new[]
        {
            // 0
            seededOffset.X + _offset.X,
            seededOffset.Y + _offset.Y,
            seededOffset.Z + _offset.Z,
            _numLayers,
            // 1
            _persistence,
            _lacunarity,
            _scale,
            _elevation,
            // 2
            _power,
            _gain,
            _verticalShift,
            _peakSmoothing
        };
        return noiseParams;
    }
}