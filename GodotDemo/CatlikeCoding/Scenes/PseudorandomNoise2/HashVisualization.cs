using CatlikeCodingFS.PseudorandomNoise2;
using Godot;

namespace CatlikeCodingCSharp.Scenes.PseudorandomNoise2;

[Tool]
public partial class HashVisualization : HashVisualizationFS
{
    private Mesh _instanceMesh;

    [Export]
    public override Mesh InstanceMesh
    {
        get => _instanceMesh;
        set
        {
            _instanceMesh = value;
            SetDirty(DirtyEnum.Normal);
        }
    }

    private Material _material;

    [Export]
    public override Material Material
    {
        get => _material;
        set
        {
            _material = value;
            SetDirty(DirtyEnum.Normal);
        }
    }

    private int _resolution = 16;

    [Export(PropertyHint.Range, "1, 512")]
    public override int Resolution
    {
        get => _resolution;
        set
        {
            _resolution = value;
            SetDirty(DirtyEnum.Resolution);
        }
    }

    private int _seed;

    [Export]
    public override int Seed
    {
        get => _seed;
        set
        {
            _seed = value;
            SetDirty(DirtyEnum.Normal);
        }
    }

    private float _displacement = 0.1f;

    [Export(PropertyHint.Range, "-0.5, 0.5")]
    public override float Displacement
    {
        get => _displacement;
        set
        {
            _displacement = value;
            SetDirty(DirtyEnum.Displacement);
        }
    }

    private static readonly Vector3 TranslationInit = Vector3.Zero;
    private static readonly Vector3 RotationInit = Vector3.Zero;
    private static readonly Vector3 ScaleInit = 8 * Vector3.One;

    private static Transform3D NewTransform(Vector3 pos, Vector3 rot, Vector3 scale) =>
        new(new Basis(Quaternion.FromEuler(DegToRad(rot))).Scaled(scale), pos);

    private static Vector3 DegToRad(Vector3 deg) =>
        new(Mathf.DegToRad(deg.X), Mathf.DegToRad(deg.Y), Mathf.DegToRad(deg.Z));

    private static Vector3 RadToDeg(Vector3 deg) =>
        new(Mathf.RadToDeg(deg.X), Mathf.RadToDeg(deg.Y), Mathf.RadToDeg(deg.Z));

    public override Transform3D Domain { get; set; } = NewTransform(TranslationInit, RotationInit, ScaleInit);

    private Vector3 _translation = TranslationInit;

    [ExportGroup("Domain")]
    [Export]
    public Vector3 Translation
    {
        get => _translation;
        set
        {
            _translation = value;
            Domain = NewTransform(_translation, _rotationD, _scaleD);
            SetDirty(DirtyEnum.Normal);
        }
    }

    private Vector3 _rotationD = RotationInit;

    [Export]
    public Vector3 RotationD
    {
        get => _rotationD;
        set
        {
            _rotationD = value;
            Domain = NewTransform(_translation, _rotationD, _scaleD);
            SetDirty(DirtyEnum.Normal);
        }
    }

    private Vector3 _scaleD = ScaleInit;

    [Export]
    public Vector3 ScaleD
    {
        get => _scaleD;
        set
        {
            _scaleD = value;
            Domain = NewTransform(_translation, _rotationD, _scaleD);
            SetDirty(DirtyEnum.Normal);
        }
    }

    // 需要忽略 IDE 省略 partial、_Ready 等的提示，必须保留它们
    public override void _Ready()
    {
        base._Ready();
        // 在 F# 里面写这个逻辑会程序集卸载失败……
        // 但监听默认变换，好像只能用这种方式。直接在 C# 种写就正常，甚至不需要上下文清理逻辑
        if (Engine.IsEditorHint())
            EditorInterface.Singleton.GetInspector().PropertyEdited += name =>
            {
                if (name is "position" or "rotation" or "scale")
                    SetDirty(DirtyEnum.Normal);
            };
    }

    public override void _Process(double delta) => base._Process(delta);
}