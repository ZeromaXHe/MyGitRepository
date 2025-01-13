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

    private ShaderMaterial _terrainMaterial;

    [Export]
    public ShaderMaterial TerrainMaterial
    {
        get => _terrainMaterial;
        set
        {
            _terrainMaterial = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private bool _hasOcean;

    [Export]
    public bool HasOcean
    {
        get => _hasOcean;
        set
        {
            _hasOcean = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
        }
    }

    private float _oceanLevel;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float OceanLevel
    {
        get => _oceanLevel;
        set
        {
            _oceanLevel = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            _hasAtmosphere = value;
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
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

    public void OnDataChanged() => EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();

    public Vector2[][] GenerateShadingData(Vector3[] vertexArray)
    {
        Rng.SetSeed((ulong)_seed);
        return _shadingDataCompute.Run(Rng, vertexArray);
    }
}