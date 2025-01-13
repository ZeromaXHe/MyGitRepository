using Godot;

namespace ProceduralPlanet.Scripts.Planet.Settings;

[Tool]
[GlobalClass]
public partial class ResolutionSettings : Resource
{
    private LodParameter[] _lodParameters = [];

    [Export]
    public LodParameter[] LodParameters
    {
        get => _lodParameters;
        set
        {
            _lodParameters = value;
            EmitChanged();
            foreach (var n in _lodParameters)
                n.Changed += OnDataChanged;
        }
    }

    private int _collider;

    [Export]
    public int Collider
    {
        get => _collider;
        set
        {
            _collider = value;
            EmitChanged();
        }
    }

    private const int MaxAllowedResolution = 500;

    public ResolutionSettings()
    {
        if (_lodParameters.Length != 0) return;
        _lodParameters = [new LodParameter(), new LodParameter(), new LodParameter()];
        _lodParameters[0].Resolution = 300;
        _lodParameters[0].MinDistance = 300;
        _lodParameters[1].Resolution = 100;
        _lodParameters[1].MinDistance = 1000;
        _lodParameters[2].Resolution = 50;
        _lodParameters[2].MinDistance = float.PositiveInfinity;
    }

    private void OnDataChanged() => EmitChanged();
    public int NumLodLevels() => _lodParameters.Length;

    public int GetLodResolution(int lodLevel) =>
        lodLevel < _lodParameters.Length ? _lodParameters[lodLevel].Resolution : _lodParameters[^1].Resolution;

    public void ClampResolutions()
    {
        foreach (var lod in _lodParameters)
            lod.Resolution = Mathf.Min(MaxAllowedResolution, lod.Resolution);
        _collider = Mathf.Min(MaxAllowedResolution, _collider);
    }
}