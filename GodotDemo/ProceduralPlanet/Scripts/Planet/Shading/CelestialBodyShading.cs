using System;
using Godot;
using ProceduralPlanet.Scripts.Planet.Settings;
using ProceduralPlanet.Scripts.Planet.Shading.Modules;
using ProceduralPlanet.Scripts.Planet.Shape;

namespace ProceduralPlanet.Scripts.Planet.Shading;

[Tool]
[GlobalClass]
public partial class CelestialBodyShading : Resource
{
    private bool _randomize;

    [Export]
    public bool Randomize
    {
        get => _randomize;
        set
        {
            var emit = _randomize != value;
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
            var emit = _seed != value;
            _seed = value;
            if (emit) EmitChanged();
        }
    }

    private ShaderMaterial _terrainMaterial;

    [Export]
    public ShaderMaterial TerrainMaterial
    {
        get => _terrainMaterial;
        set
        {
            _terrainMaterial = value;
            EmitChanged();
        }
    }

    private bool _hasOcean;

    [Export]
    public bool HasOcean
    {
        get => _hasOcean;
        set
        {
            var emit = _hasOcean != value;
            _hasOcean = value;
            if (emit) EmitChanged();
        }
    }

    private float _oceanLevel;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float OceanLevel
    {
        get => _oceanLevel;
        set
        {
            var emit = Math.Abs(_oceanLevel - value) > 0.001f;
            _oceanLevel = value;
            if (emit) EmitChanged();
        }
    }

    private OceanSettings _oceanSettings;

    [Export]
    public OceanSettings OceanSettings
    {
        get => _oceanSettings;
        set
        {
            _oceanSettings = value;
            _oceanSettings.ResourceName = "海洋设置";
            EmitChanged();
            _oceanSettings.Changed += OnDataChanged;
        }
    }

    private bool _hasAtmosphere;

    [Export]
    public bool HasAtmosphere
    {
        get => _hasAtmosphere;
        set
        {
            var emit = _hasAtmosphere != value;
            _hasAtmosphere = value;
            if (emit) EmitChanged();
        }
    }

    private AtmosphereSettings _atmosphereSettings;

    [Export]
    public AtmosphereSettings AtmosphereSettings
    {
        get => _atmosphereSettings;
        set
        {
            _atmosphereSettings = value;
            _atmosphereSettings.ResourceName = "大气设置";
            EmitChanged();
            _atmosphereSettings.Changed += OnDataChanged;
        }
    }

    private ShadingDataModule _shadingDataCompute;

    [Export]
    public ShadingDataModule ShadingDataCompute
    {
        get => _shadingDataCompute;
        set
        {
            _shadingDataCompute = value;
            _shadingDataCompute.ResourceName = "着色数据计算着色器";
            EmitChanged();
            _shadingDataCompute.Changed += OnDataChanged;
        }
    }

    private Vector2[] _cachedShadingData;
    protected RandomNumberGenerator Rng = new();

    // 初始化
    public virtual void Initialize(CelestialBodyShape shape)
    {
    }

    // 设置着色器属性受检查地形
    public virtual void SetTerrainProperties(ShaderMaterial material, Vector2 heightMinMax, float bodyScale)
    {
    }

    public void SetOceanProperties(ShaderMaterial material) =>
        _oceanSettings.SetProperties(material, _seed, _randomize);

    public void OnDataChanged() => EmitChanged();

    public Vector2[][] GenerateShadingData(Vector3[] vertexArray)
    {
        Rng.SetSeed((ulong)_seed);
        return _shadingDataCompute.Run(Rng, vertexArray);
    }
}