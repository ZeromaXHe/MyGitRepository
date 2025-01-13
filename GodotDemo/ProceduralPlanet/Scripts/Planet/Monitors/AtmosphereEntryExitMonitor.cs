using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Effects;

namespace ProceduralPlanet.Scripts.Planet.Monitors;

public partial class AtmosphereEntryExitMonitor : Node3D
{
    [Export] public CelestialBodyGenerator Planet;
    [Export] public float ShakeStrength = 40f;

    private Array<Area3D> _prevIntersectingAreas = [];

    private Area3D _atmosphereInner;
    private Area3D _atmosphereOuter;
    private CollisionShape3D _atmosphereInnerCollider;
    private CollisionShape3D _atmosphereOuterCollider;

    public override void _Ready()
    {
        _atmosphereInner = GetNode<Area3D>("AtmosphereInner");
        _atmosphereOuter = GetNode<Area3D>("AtmosphereOuter");
        _atmosphereInnerCollider = GetNode<CollisionShape3D>("AtmosphereInner/AtmosphereInnerCollider");
        _atmosphereOuterCollider = GetNode<CollisionShape3D>("AtmosphereOuter/AtmosphereOuterCollider");

        var atmosphereRadius = (1f + Planet.Body.Shading.AtmosphereSettings.AtmosphereScale) * Planet.BodyScale();
        // 内部边界在 30% 大气层厚度开始
        ((SphereShape3D)_atmosphereInnerCollider.Shape).Radius =
            Planet.BodyScale() + 0.3f * (atmosphereRadius - Planet.BodyScale());
        // 外部边界在 130% 大气层厚度结束
        ((SphereShape3D)_atmosphereOuterCollider.Shape).Radius =
            Planet.BodyScale() + 1.3f * (atmosphereRadius - Planet.BodyScale());
    }

    public override void _PhysicsProcess(double delta)
    {
        var intersectingAreas = new Array<Area3D>();
        var overlappingAreasInner = _atmosphereInner.GetOverlappingAreas();
        var overlappingAreasOuter = _atmosphereOuter.GetOverlappingAreas();
        foreach (var otherArea in overlappingAreasOuter)
        {
            if (overlappingAreasInner.Contains(otherArea)) continue;
            var shakeEffect = GetShakeEffect(otherArea);
            if (shakeEffect != null)
                shakeEffect.IsShaking = true;
            var audioPlayer = GetAudioStreamPlayer3D(otherArea);
            if (audioPlayer != null && !audioPlayer.Playing)
                audioPlayer.Playing = true;
            intersectingAreas.Add(otherArea);
        }

        foreach (var area in _prevIntersectingAreas)
        {
            if (!intersectingAreas.Contains(area))
            {
                var shakeEffect = GetShakeEffect(area);
                if (shakeEffect != null)
                    shakeEffect.IsShaking = false;
                if (overlappingAreasInner.Contains(area))
                    continue;
                var audioPlayer = GetAudioStreamPlayer3D(area);
                if (audioPlayer is { Playing: true })
                    audioPlayer.Playing = false;
            }
            else
            {
                var innerRadius = ((SphereShape3D)_atmosphereInnerCollider.Shape).Radius;
                var outerRadius = ((SphereShape3D)_atmosphereOuterCollider.Shape).Radius;
                var innerDist = Mathf.Abs(area.GlobalPosition.DistanceTo(GlobalPosition) - innerRadius);
                var outerDist = Mathf.Abs(area.GlobalPosition.DistanceTo(GlobalPosition) - outerRadius);
                var atmosphereThickness = outerRadius - innerRadius;
                var shakeEffect = GetShakeEffect(area);
                if (shakeEffect != null)
                    shakeEffect.Speed = ShakeStrength * (1f - Mathf.Abs(outerDist - innerDist) / atmosphereThickness);
                var audioPlayer = GetAudioStreamPlayer3D(area);
                if (audioPlayer == null)
                    continue;
                var expRatio = Mathf.Exp(-(Mathf.Abs(outerDist - innerDist) / atmosphereThickness));
                audioPlayer.VolumeDb = -80f + 80f * Mathf.Min(1f, expRatio);
                audioPlayer.MaxDb = -24f + 24f * Mathf.Min(1f, expRatio);
            }
        }

        _prevIntersectingAreas = intersectingAreas;
    }

    private ShakeEffect GetShakeEffect(Node node)
    {
        foreach (var child in node.GetParent().GetChildren())
            if (child is ShakeEffect shakeEffect)
                return shakeEffect;
        return null;
    }

    private AudioStreamPlayer3D GetAudioStreamPlayer3D(Node node)
    {
        foreach (var child in node.GetParent().GetChildren())
            if (child is AudioStreamPlayer3D audioPlayer && child.IsInGroup("AtmosphereEffect"))
                return audioPlayer;
        return null;
    }
}