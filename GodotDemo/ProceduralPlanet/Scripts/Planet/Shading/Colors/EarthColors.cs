using Godot;

namespace ProceduralPlanet.Scripts.Planet.Shading.Colors;

[Tool]
[GlobalClass]
public partial class EarthColors : Resource
{
    private Color _shoreColorLow;

    [Export]
    public Color ShoreColorLow
    {
        get => _shoreColorLow;
        set
        {
            var emit = value != _shoreColorLow;
            _shoreColorLow = value;
            if (emit) EmitChanged();
        }
    }

    private Color _shoreColorHigh;

    [Export]
    public Color ShoreColorHigh
    {
        get => _shoreColorHigh;
        set
        {
            var emit = value != _shoreColorHigh;
            _shoreColorHigh = value;
            if (emit) EmitChanged();
        }
    }

    private Color _flatColorLowA;

    [Export]
    public Color FlatColorLowA
    {
        get => _flatColorLowA;
        set
        {
            var emit = value != _flatColorLowA;
            _flatColorLowA = value;
            if (emit) EmitChanged();
        }
    }

    private Color _flatColorHighA;

    [Export]
    public Color FlatColorHighA
    {
        get => _flatColorHighA;
        set
        {
            var emit = value != _flatColorHighA;
            _flatColorHighA = value;
            if (emit) EmitChanged();
        }
    }

    private Color _flatColorLowB;

    [Export]
    public Color FlatColorLowB
    {
        get => _flatColorLowB;
        set
        {
            var emit = value != _flatColorLowB;
            _flatColorLowB = value;
            if (emit) EmitChanged();
        }
    }

    private Color _flatColorHighB;

    [Export]
    public Color FlatColorHighB
    {
        get => _flatColorHighB;
        set
        {
            var emit = value != _flatColorHighB;
            _flatColorHighB = value;
            if (emit) EmitChanged();
        }
    }

    private Color _steepLow;

    [Export]
    public Color SteepLow
    {
        get => _steepLow;
        set
        {
            var emit = value != _steepLow;
            _steepLow = value;
            if (emit) EmitChanged();
        }
    }

    private Color _steepHigh;

    [Export]
    public Color SteepHigh
    {
        get => _steepHigh;
        set
        {
            var emit = value != _steepHigh;
            _steepHigh = value;
            if (emit) EmitChanged();
        }
    }
}