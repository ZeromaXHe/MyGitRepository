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
            _randomize = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }
    private int _seed;

    [Export]
    public int Seed
    {
        get => _seed;
        set
        {
            _seed = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            _perturbVertices = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            _perturbStrength = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private float[] _heightBuffer;
    private RandomNumberGenerator _rng = new();
    
    private void OnDataChanged() => EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();

    public float[] CalculateHeights(Vector3[] vertexArray)
    {
        _rng.SetSeed((ulong)_seed);
        return _heightMapCompute.Run(_rng, vertexArray);
    }
}