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
            _shoreColorLow = value;
            EmitChanged();
        }
    }

    private Color _shoreColorHigh;

    [Export]
    public Color ShoreColorHigh
    {
        get => _shoreColorHigh;
        set
        {
            _shoreColorHigh = value;
            EmitChanged();
        }
    }

    private Color _flatColorLowA;

    [Export]
    public Color FlatColorLowA
    {
        get => _flatColorLowA;
        set
        {
            _flatColorLowA = value;
            EmitChanged();
        }
    }

    private Color _flatColorHighA;

    [Export]
    public Color FlatColorHighA
    {
        get => _flatColorHighA;
        set
        {
            _flatColorHighA = value;
            EmitChanged();
        }
    }

    private Color _flatColorLowB;

    [Export]
    public Color FlatColorLowB
    {
        get => _flatColorLowB;
        set
        {
            _flatColorLowB = value;
            EmitChanged();
        }
    }

    private Color _flatColorHighB;

    [Export]
    public Color FlatColorHighB
    {
        get => _flatColorHighB;
        set
        {
            _flatColorHighB = value;
            EmitChanged();
        }
    }

    private Color _steepLow;

    [Export]
    public Color SteepLow
    {
        get => _steepLow;
        set
        {
            _steepLow = value;
            EmitChanged();
        }
    }

    private Color _steepHigh;

    [Export]
    public Color SteepHigh
    {
        get => _steepHigh;
        set
        {
            _steepHigh = value;
            EmitChanged();
        }
    }
}