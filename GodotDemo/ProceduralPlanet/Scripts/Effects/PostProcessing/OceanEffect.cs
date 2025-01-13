using Godot;
using ProceduralPlanet.Scripts.Planet;

namespace ProceduralPlanet.Scripts.Effects.PostProcessing;

[Tool]
public partial class OceanEffect : Node
{
    private Node3D _light;
    private ShaderMaterial _material;

    public OceanEffect()
    {
    }

    public OceanEffect(Node3D light) => _light = light;

    public void UpdateSettings(SubViewport sourceViewport, CelestialBodyGenerator generator, Shader shader)
    {
        if (_material == null || _material.Shader != shader)
        {
            _material = new ShaderMaterial();
            _material.Shader = shader;
            _material.RenderPriority = -1;
        }

        var center = generator.GlobalPosition;
        var radius = generator.GetOceanRadius();
        _material.SetShaderParameter("OceanCentre", center);
        _material.SetShaderParameter("OceanRadius", radius);

        var tex = sourceViewport.GetTexture();
        _material.SetShaderParameter("MainTex", tex);
        _material.SetShaderParameter("PlanetScale", generator.BodyScale());

        if (_light != null)
            _material.SetShaderParameter("DirToSun", (_light.GlobalPosition - center).Normalized());
        else
        {
            _material.SetShaderParameter("DirToSun", Vector3.Up);
            GD.Print("OceanEffect | 没有找到 DirectionalLight3D");
        }

        generator.Body.Shading.SetOceanProperties(_material);
    }

    public ShaderMaterial GetMaterial() => _material;
}