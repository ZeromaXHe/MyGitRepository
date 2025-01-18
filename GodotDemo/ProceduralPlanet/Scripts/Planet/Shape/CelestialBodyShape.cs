using System;
using Godot;
using ProceduralPlanet.Scripts.Planet.Shape.Modules;

namespace ProceduralPlanet.Scripts.Planet.Shape;

[Tool]
[GlobalClass]
public partial class CelestialBodyShape : Resource
{
    private bool _randomize;

    [Export]
    public bool Randomize
    {
        get => _randomize;
        set
        {
            var emit = value != _randomize;
            _randomize = value;
            if (emit) EmitChanged();
        }
    }

    private int _seed;

    [Export]
    public int Seed
    {
        get => _seed;
        set
        {
            var emit = value != _seed;
            _seed = value;
            if (emit) EmitChanged();
        }
    }

    private HeightModule _heightMapCompute;

    [Export]
    public HeightModule HeightMapCompute
    {
        get => _heightMapCompute;
        set
        {
            _heightMapCompute = value;
            _heightMapCompute.ResourceName = "高度模块";
            EmitChanged();
            _heightMapCompute.Changed += OnDataChanged;
        }
    }

    private bool _perturbVertices;

    [Export]
    public bool PerturbVertices
    {
        get => _perturbVertices;
        set
        {
            var emit = value != _perturbVertices;
            _perturbVertices = value;
            if (emit) EmitChanged();
        }
    }

    private PerturbModule _perturbCompute;

    [Export]
    public PerturbModule PerturbCompute
    {
        get => _perturbCompute;
        set
        {
            _perturbCompute = value;
            _perturbCompute.ResourceName = "扰动模块";
            EmitChanged();
            _perturbCompute.Changed += OnDataChanged;
        }
    }

    private float _perturbStrength = 0.7f;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float PerturbStrength
    {
        get => _perturbStrength;
        set
        {
            var emit = Math.Abs(value - _perturbStrength) > 0.001f;
            _perturbStrength = value;
            if (emit) EmitChanged();
        }
    }

    private float[] _heightBuffer;
    private RandomNumberGenerator _rng = new();

    private void OnDataChanged() => EmitChanged();

    public float[] CalculateHeights(Vector3[] vertexArray)
    {
        _rng.SetSeed((ulong)_seed);
        return _heightMapCompute.Run(_rng, vertexArray);
    }
}