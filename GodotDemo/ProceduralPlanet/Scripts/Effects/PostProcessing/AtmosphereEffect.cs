using Godot;
using ProceduralPlanet.Scripts.Planet;

namespace ProceduralPlanet.Scripts.Effects.PostProcessing;

[Tool]
public partial class AtmosphereEffect : Node
{
    private Node3D _light;
    private ShaderMaterial _material;

    public AtmosphereEffect()
    {
    }

    public AtmosphereEffect(Node3D light) => _light = light;

    public void UpdateSettings(SubViewport sourceViewport, CelestialBodyGenerator generator, Shader shader)
    {
        if (_material == null || _material.Shader != shader)
        {
            _material = new ShaderMaterial();
            _material.Shader = shader;
            _material.RenderPriority = -1;
        }

        generator.Body.Shading.AtmosphereSettings.SetProperties(_material, generator.BodyScale());

        var center = generator.GlobalPosition;
        var radius = generator.GetOceanRadius();
        _material.SetShaderParameter("PlanetCentre", center);
        _material.SetShaderParameter("OceanRadius", radius);

        var tex = sourceViewport.GetTexture();
        _material.SetShaderParameter("MainTex", tex);
        _material.SetShaderParameter("ScreenWidth", sourceViewport.Size.X);
        _material.SetShaderParameter("ScreenHeight", sourceViewport.Size.Y);

        if (_light != null)
            _material.SetShaderParameter("DirToSun", (_light.GlobalPosition - center).Normalized());
        else
        {
            _material.SetShaderParameter("DirToSun", Vector3.Up);
            GD.Print("AtmosphereEffect | 没有找到 DirectionalLight3D");
        }
    }

    public ShaderMaterial GetMaterial() => _material;
}