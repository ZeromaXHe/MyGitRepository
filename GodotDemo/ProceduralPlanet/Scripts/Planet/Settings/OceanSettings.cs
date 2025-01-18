using System;
using Godot;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet.Settings;

[Tool]
[GlobalClass]
public partial class OceanSettings : Resource
{
    private float _depthMultiplier = 10f;

    [Export]
    public float DepthMultiplier
    {
        get => _depthMultiplier;
        set
        {
            var emit = Math.Abs(value - _depthMultiplier) > 0.001f;
            _depthMultiplier = value;
            if (emit) EmitChanged();
        }
    }

    private float _alphaMultiplier = 70f;

    [Export]
    public float AlphaMultiplier
    {
        get => _alphaMultiplier;
        set
        {
            var emit = Math.Abs(value - _alphaMultiplier) > 0.001f;
            _alphaMultiplier = value;
            if (emit) EmitChanged();
        }
    }

    private Color _colA;

    [Export]
    public Color ColA
    {
        get => _colA;
        set
        {
            var emit = value != _colA;
            _colA = value;
            if (emit) EmitChanged();
        }
    }

    private Color _colB;

    [Export]
    public Color ColB
    {
        get => _colB;
        set
        {
            var emit = value != _colB;
            _colB = value;
            if (emit) EmitChanged();
        }
    }

    private Color _specularCol = new(1, 1, 1);

    [Export]
    public Color SpecularCol
    {
        get => _specularCol;
        set
        {
            var emit = value != _specularCol;
            _specularCol = value;
            if (emit) EmitChanged();
        }
    }

    private Texture2D _waveNormalA;

    [Export]
    public Texture2D WaveNormalA
    {
        get => _waveNormalA;
        set
        {
            var emit = value != _waveNormalA;
            _waveNormalA = value;
            if (emit) EmitChanged();
        }
    }

    private Texture2D _waveNormalB;

    [Export]
    public Texture2D WaveNormalB
    {
        get => _waveNormalB;
        set
        {
            var emit = value != _waveNormalB;
            _waveNormalB = value;
            if (emit) EmitChanged();
        }
    }

    private float _waveStrength = 0.15f;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float WaveStrength
    {
        get => _waveStrength;
        set
        {
            var emit = Math.Abs(value - _waveStrength) > 0.001f;
            _waveStrength = value;
            if (emit) EmitChanged();
        }
    }

    private float _waveScale = 15f;

    [Export]
    public float WaveScale
    {
        get => _waveScale;
        set
        {
            var emit = Math.Abs(value - _waveScale) > 0.001f;
            _waveScale = value;
            if (emit) EmitChanged();
        }
    }

    private float _waveSpeed = 0.5f;

    [Export]
    public float WaveSpeed
    {
        get => _waveSpeed;
        set
        {
            var emit = Math.Abs(value - _waveSpeed) > 0.001f;
            _waveSpeed = value;
            if (emit) EmitChanged();
        }
    }

    private float _shoreWaveHeight = 0.1f;

    [Export]
    public float ShoreWaveHeight
    {
        get => _shoreWaveHeight;
        set
        {
            var emit = Math.Abs(value - _shoreWaveHeight) > 0.001f;
            _shoreWaveHeight = value;
            if (emit) EmitChanged();
        }
    }

    private float _smoothness = 0.92f;

    [Export(PropertyHint.Range, "0.0, 1.0")]
    public float Smoothness
    {
        get => _smoothness;
        set
        {
            var emit = Math.Abs(value - _smoothness) > 0.001f;
            _smoothness = value;
            if (emit) EmitChanged();
        }
    }

    private float _specularIntensity = 0.5f;

    [Export]
    public float SpecularIntensity
    {
        get => _specularIntensity;
        set
        {
            var emit = Math.Abs(value - _specularIntensity) > 0.001f;
            _specularIntensity = value;
            if (emit) EmitChanged();
        }
    }

    private Texture2D _foamNoiseTexture;

    [Export]
    public Texture2D FoamNoiseTexture
    {
        get => _foamNoiseTexture;
        set
        {
            var emit = value != _foamNoiseTexture;
            _foamNoiseTexture = value;
            if (emit) EmitChanged();
        }
    }

    private Color _foamColor;

    [Export]
    public Color FoamColor
    {
        get => _foamColor;
        set
        {
            var emit = value != _foamColor;
            _foamColor = value;
            if (emit) EmitChanged();
        }
    }

    private float _foamNoiseScale = 1f;

    [Export]
    public float FoamNoiseScale
    {
        get => _foamNoiseScale;
        set
        {
            var emit = Math.Abs(value - _foamNoiseScale) > 0.001f;
            _foamNoiseScale = value;
            if (emit) EmitChanged();
        }
    }

    private float _foamFalloffDistance = 0.5f;

    [Export]
    public float FoamFalloffDistance
    {
        get => _foamFalloffDistance;
        set
        {
            var emit = Math.Abs(value - _foamFalloffDistance) > 0.001f;
            _foamFalloffDistance = value;
            if (emit) EmitChanged();
        }
    }

    private float _foamLeadingEdgeFalloff = 1f;

    [Export]
    public float FoamLeadingEdgeFalloff
    {
        get => _foamLeadingEdgeFalloff;
        set
        {
            var emit = Math.Abs(value - _foamLeadingEdgeFalloff) > 0.001f;
            _foamLeadingEdgeFalloff = value;
            if (emit) EmitChanged();
        }
    }

    private float _foamEdgeFalloffBias = 0.5f;

    [Export]
    public float FoamEdgeFalloffBias
    {
        get => _foamEdgeFalloffBias;
        set
        {
            var emit = Math.Abs(value - _foamEdgeFalloffBias) > 0.001f;
            _foamEdgeFalloffBias = value;
            if (emit) EmitChanged();
        }
    }

    private float _refractionScale = 1f;

    [Export(PropertyHint.Range, "0.0, 2.0")]
    public float RefractionScale
    {
        get => _refractionScale;
        set
        {
            var emit = Math.Abs(value - _refractionScale) > 0.001f;
            _refractionScale = value;
            if (emit) EmitChanged();
        }
    }

    private RandomNumberGenerator _rng = new();

    public void SetProperties(ShaderMaterial material, int seed, bool randomize)
    {
        material.SetShaderParameter("DepthMultiplier", _depthMultiplier);
        material.SetShaderParameter("AlphaMultiplier", _alphaMultiplier);
        material.SetShaderParameter("WaveNormalA", _waveNormalA);
        material.SetShaderParameter("WaveNormalB", _waveNormalB);
        material.SetShaderParameter("WaveStrength", _waveStrength);
        material.SetShaderParameter("WaveNormalScale", _waveScale);
        material.SetShaderParameter("WaveSpeed", _waveSpeed);
        material.SetShaderParameter("ShoreWaveHeight", _shoreWaveHeight);
        material.SetShaderParameter("Smoothness", _smoothness);
        material.SetShaderParameter("SpecularIntensity", _specularIntensity);
        material.SetShaderParameter("FoamNoiseTexture", _foamNoiseTexture);
        material.SetShaderParameter("FoamColor", _foamColor);
        material.SetShaderParameter("FoamNoiseScale", _foamNoiseScale);
        material.SetShaderParameter("FoamFalloffDistance", _foamFalloffDistance);
        material.SetShaderParameter("FoamLeadingEdgeFalloff", _foamLeadingEdgeFalloff);
        material.SetShaderParameter("FoamEdgeFalloffBias", _foamEdgeFalloffBias);
        material.SetShaderParameter("RefractionScale", _refractionScale);
        if (randomize)
        {
            _rng.SetSeed((uint)seed);
            _rng.Randomize();
            var randomColA = Color.FromHsv(_rng.Randf(), _rng.RandfRange(0.6f, 0.8f), _rng.RandfRange(0.65f, 1f));
            var randomColB = ColorUtils.TweakHsv(randomColA, MathUtils.RandSigned(_rng) * 0.2f,
                MathUtils.RandSigned(_rng) * 0.2f, _rng.RandfRange(-0.5f, 0.4f));
            material.SetShaderParameter("ColA", randomColA);
            material.SetShaderParameter("ColB", randomColB);
            material.SetShaderParameter("SpecularCol", new Color(1, 1, 1));
        }
        else
        {
            material.SetShaderParameter("ColA", _colA);
            material.SetShaderParameter("ColB", _colB);
            material.SetShaderParameter("SpecularCol", _specularCol);
        }
    }
}