using Godot;

namespace ProceduralPlanet.Scripts.Effects;

public partial class ShakeEffect : Node
{
    [Export] public bool Enabled { get; set; } = true;
    [Export] public bool IsShaking { get; set; } = false;
    [Export] public Vector3 Amount { get; set; } = Vector3.Zero;
    [Export] public float Speed { get; set; } = 0f;

    private RandomNumberGenerator _rng = new();
    private Vector3 _prevDiff = Vector3.Zero;

    public override void _Process(double delta)
    {
        var cam = GetParent() as Camera3D;
        var isParentCurrentCam = cam?.Current ?? false;
        if (!(isParentCurrentCam && Enabled))
            return;
        // 摄像机回中
        cam.Position -= _prevDiff;
        _prevDiff = Vector3.Zero;
        if (!IsShaking)
            return;
        // 随机振动摄像机
        var vec = new Vector3(_rng.RandfRange(-1, 1), _rng.RandfRange(-1, 1), _rng.RandfRange(-1, 1));
        var diff = cam.GlobalTransform.Basis * Amount * vec * Speed * (float)delta;
        cam.Position += diff;
        _prevDiff = diff;
    }
}