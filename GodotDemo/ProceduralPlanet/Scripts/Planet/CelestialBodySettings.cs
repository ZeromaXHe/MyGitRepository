using Godot;
using ProceduralPlanet.Scripts.Planet.Shading;
using ProceduralPlanet.Scripts.Planet.Shape;

namespace ProceduralPlanet.Scripts.Planet;

[Tool]
[GlobalClass]
public partial class CelestialBodySettings : Resource
{
    [Signal]
    public delegate void ShapeChangedEventHandler();

    [Signal]
    public delegate void ShadeChangedEventHandler();

    private CelestialBodyShape _shape;

    [Export]
    public CelestialBodyShape Shape
    {
        get => _shape;
        set
        {
            _shape = value;
            EmitSignal(SignalName.ShadeChanged);
            _shape.Changed += OnShapeDataChanged;
        }
    }

    private CelestialBodyShading _shading;

    [Export]
    public CelestialBodyShading Shading
    {
        get => _shading;
        set
        {
            _shading = value;
            EmitSignal(SignalName.ShadeChanged);
            _shading.Changed += OnShadeDataChanged;
        }
    }

    private void OnShapeDataChanged() => EmitSignal(SignalName.ShapeChanged);
    private void OnShadeDataChanged() => EmitSignal(SignalName.ShadeChanged);
}