using Godot;
using ProceduralPlanet.Scripts.Planet.Shading.Colors;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Shading;

[Tool]
[GlobalClass]
public partial class EarthShading : CelestialBodyShading
{
    private EarthColors _customizedColors;

    [Export]
    public EarthColors CustomizedColors
    {
        get => _customizedColors;
        set
        {
            _customizedColors = value;
            _customizedColors.ResourceName = "自定义颜色";
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _customizedColors.Changed += OnDateChanged;
        }
    }

    private EarthColors _randomizedColors;

    [Export]
    public EarthColors RandomizedColors
    {
        get => _randomizedColors;
        set
        {
            _randomizedColors = value;
            _randomizedColors.ResourceName = "随机颜色";
            EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();
            _randomizedColors.Changed += OnDateChanged;
        }
    }

    private void OnDateChanged() => EmitSignal(Resource.SignalName.Changed); // 等同于 EmitChanged();

    public override void SetTerrainProperties(ShaderMaterial material, Vector2 heightMinMax, float bodyScale)
    {
        material.SetShaderParameter("HeightMinMax", heightMinMax);
        material.SetShaderParameter("OceanLevel", OceanLevel);
        material.SetShaderParameter("BodyScale", bodyScale);
        if (Randomize)
        {
            SetRandomColors(material);
            ApplyColors(material, _randomizedColors);
        }
        else
        {
            ApplyColors(material, _customizedColors);
        }
    }

    private void ApplyColors(ShaderMaterial material, EarthColors colors)
    {
        material.SetShaderParameter("ShoreLow", colors.ShoreColorLow);
        material.SetShaderParameter("ShoreHigh", colors.ShoreColorHigh);
        material.SetShaderParameter("FlatLowA", colors.FlatColorLowA);
        material.SetShaderParameter("FlatHighA", colors.FlatColorHighA);
        material.SetShaderParameter("FlatLowB", colors.FlatColorLowB);
        material.SetShaderParameter("FlatHighB", colors.FlatColorHighB);
        material.SetShaderParameter("SteepLow", colors.SteepLow);
        material.SetShaderParameter("SteepHigh", colors.SteepHigh);
    }

    private void SetRandomColors(ShaderMaterial material)
    {
        Rng.Randomize();
        _randomizedColors.FlatColorLowA = ColorUtils.RandomColor(Rng, 0.45f, 0.6f, 0.7f, 0.8f);
        _randomizedColors.FlatColorHighA = ColorUtils.TweakHsv(_randomizedColors.FlatColorLowA,
            MathUtils.RandSigned(Rng) * 0.2f, MathUtils.RandSigned(Rng) * 0.15f, Rng.RandfRange(-0.25f, 0.2f));
        _randomizedColors.FlatColorLowB = ColorUtils.RandomColor(Rng, 0.45f, 0.6f, 0.7f, 0.8f);
        _randomizedColors.FlatColorHighB = ColorUtils.TweakHsv(_randomizedColors.FlatColorLowB,
            MathUtils.RandSigned(Rng) * 0.2f, MathUtils.RandSigned(Rng) * 0.15f, Rng.RandfRange(-0.25f, 0.2f));
        _randomizedColors.ShoreColorLow = ColorUtils.RandomColor(Rng, 0.2f, 0.3f, 0.9f, 1f);
        _randomizedColors.ShoreColorHigh = ColorUtils.TweakHsv(_randomizedColors.ShoreColorLow,
            MathUtils.RandSigned(Rng) * 0.2f, MathUtils.RandSigned(Rng) * 0.2f, Rng.RandfRange(-0.3f, 0.2f));
        _randomizedColors.SteepLow = ColorUtils.RandomColor(Rng, 0.3f, 0.7f, 0.4f, 0.6f);
        _randomizedColors.SteepHigh = ColorUtils.TweakHsv(_randomizedColors.SteepLow,
            MathUtils.RandSigned(Rng) * 0.2f, MathUtils.RandSigned(Rng) * 0.2f, Rng.RandfRange(-0.35f, 0.2f));
    }
}