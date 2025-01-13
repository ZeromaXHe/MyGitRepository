using Godot;
using ProceduralPlanet.Scripts.Planet;

namespace ProceduralPlanet.Scripts.Effects.PostProcessing;

[Tool]
public partial class PlanetEffects : Node
{
    [Export] public bool DisplayOceans = true;
    [Export] public bool DisplayAtmosphere = false;
    [Export] public Shader OceanShader;

    [Export] public Shader AtmosphereShader;

    // 后处理效果是 ShaderMaterials slapped 到公告板四边形上，并按在你脸上
    [Export] public MeshInstance3D OceanTargetMesh;

    [Export] public MeshInstance3D AtmosphereTargetMesh;

    // 一个有光源子节点的节点
    [Export] public Node3D Light;

    // 一个 CelestialBodyGenerator 节点
    [Export] public CelestialBodyGenerator Generator;

    // 我们使用 Viewports 作为一个 Godot 没有多通道后处理的替代品
    [Export] public SubViewport SourceViewport;
    [Export] public SubViewport OceanViewport;

    [Export] public SubViewport AtmosphereViewport;

    // 持有我们后处理效果代码
    private PlanetEffectHolder _effectHolder;

    // TODO: 其实需要合适的多通道后处理流水线来做这个
    public override void _Process(double delta)
    {
        if (Generator == null || Light == null) return;
        // 源 Viewport 是我们没有任何效果的视图
        var nextViewport = SourceViewport;
        // 初始化我们的效果持有器
        _effectHolder ??= new PlanetEffectHolder(Generator, Light);

        // 海洋后处理效果
        if (DisplayOceans && _effectHolder.OceanEffect != null)
        {
            _effectHolder.OceanEffect.UpdateSettings(nextViewport, _effectHolder.Generator, OceanShader);
            OceanTargetMesh.MaterialOverride = _effectHolder.OceanEffect.GetMaterial();
            nextViewport = OceanViewport;
        }
        
        // 大气层后处理效果
        if (DisplayAtmosphere && _effectHolder.AtmosphereEffect != null)
        {
            _effectHolder.AtmosphereEffect.UpdateSettings(nextViewport, _effectHolder.Generator, AtmosphereShader);
            AtmosphereTargetMesh.MaterialOverride = _effectHolder.AtmosphereEffect.GetMaterial();
            nextViewport = AtmosphereViewport;
        }
    }
}