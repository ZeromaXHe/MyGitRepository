using System.Linq;
using System.Numerics;
using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Planet;
using Vector2 = Godot.Vector2;
using Vector3 = Godot.Vector3;

namespace ProceduralPlanet.Scripts.Stars;

[Tool]
public partial class Stars : Node3D
{
    private int _seed = 0;

    [Export]
    public int Seed
    {
        get => _seed;
        set
        {
            _seed = value;
            OnDataUpdated();
        }
    }

    private int _numStars = 0;

    [Export]
    public int NumStars
    {
        get => _numStars;
        set
        {
            _numStars = value;
            OnDataUpdated();
        }
    }

    private int _numVertsPerStar = 5;

    [Export]
    public int NumVertsPerStar
    {
        get => _numVertsPerStar;
        set
        {
            _numVertsPerStar = value;
            OnDataUpdated();
        }
    }

    private Vector2 _sizeMinMax;

    [Export]
    public Vector2 SizeMinMax
    {
        get => _sizeMinMax;
        set
        {
            _sizeMinMax = value;
            OnDataUpdated();
        }
    }

    private float _minBrightness = 0f;

    [Export]
    public float MinBrightness
    {
        get => _minBrightness;
        set
        {
            _minBrightness = value;
            OnDataUpdated();
        }
    }

    private float _maxBrightness = 1f;

    [Export]
    public float MaxBrightness
    {
        get => _maxBrightness;
        set
        {
            _maxBrightness = value;
            OnDataUpdated();
        }
    }

    private float _distance = 10f;

    [Export]
    public float Distance
    {
        get => _distance;
        set
        {
            _distance = value;
            OnDataUpdated();
        }
    }

    // 更高的值意味着需要更暗才会显示星星
    private float _dayTimeFade = 4f;

    [Export]
    public float DayTimeFade
    {
        get => _dayTimeFade;
        set
        {
            _dayTimeFade = value;
            OnDataUpdated();
        }
    }

    private ShaderMaterial _material;

    [Export]
    public ShaderMaterial Material
    {
        get => _material;
        set
        {
            _material = value;
            OnDataUpdated();
        }
    }

    private GradientTexture2D _colorSpectrum;

    [Export]
    public GradientTexture2D ColorSpectrum
    {
        get => _colorSpectrum;
        set
        {
            _colorSpectrum = value;
            OnDataUpdated();
            _colorSpectrum.Changed += OnDataUpdated;
        }
    }

    private GradientTexture2D _clusterColorSpectrum;

    [Export]
    public GradientTexture2D ClusterColorSpectrum
    {
        get => _clusterColorSpectrum;
        set
        {
            _clusterColorSpectrum = value;
            OnDataUpdated();
            _clusterColorSpectrum.Changed += OnDataUpdated;
        }
    }

    private FastNoiseLite _starsClusteringNoise;

    [Export]
    public FastNoiseLite StarsClusteringNoise
    {
        get => _starsClusteringNoise;
        set
        {
            _starsClusteringNoise = value;
            OnDataUpdated();
            _starsClusteringNoise.Changed += OnDataUpdated;
        }
    }

    private float _starsClusteringAmplitude = 1f;

    [Export(PropertyHint.Range, "0.0, 10.0")]
    public float StarsClusteringAmplitude
    {
        get => _starsClusteringAmplitude;
        set
        {
            _starsClusteringAmplitude = value;
            OnDataUpdated();
        }
    }

    [Export] public CelestialBodyGenerator Generator;
    [Export] public Viewport SourceViewport;

    private Camera3D _cam;
    private bool _settingsUpdated = false;
    private RandomNumberGenerator _rng = new();

    public override void _Ready()
    {
        _settingsUpdated = true;
        Initialize(_settingsUpdated);
    }

    public override void _Process(double delta)
    {
        Initialize(_settingsUpdated);
        _settingsUpdated = false;
    }

    private void OnDataUpdated()
    {
        _settingsUpdated = true;
    }

    private void Initialize(bool regenerateMesh)
    {
        if (regenerateMesh)
            GenerateMesh();

        _cam = GetViewport().GetCamera3D();

        _material?.SetShaderParameter("MainTex", SourceViewport.GetTexture());
        _material?.SetShaderParameter("Spectrum", _colorSpectrum);
        _material?.SetShaderParameter("ClusterSpectrum", _clusterColorSpectrum);
        _material?.SetShaderParameter("daytimeFade", _dayTimeFade);
        _material?.SetShaderParameter("OceanRadius", Generator.GetOceanRadius());
        _material?.SetShaderParameter("PlanetCentre", Generator.GlobalPosition);
    }

    private void GenerateMesh()
    {
        var mesh = new ArrayMesh();
        var arrays = new Array();
        arrays.Resize((int)Mesh.ArrayType.Max);
        var vertices = new Array<Vector3>();
        var triangles = new Array<int>();
        var uvs = new Array<Vector2>();
        var cols = new Array<Color>();
        _rng.SetSeed((ulong)_seed);
        for (var i = 0; i < _numStars; i++)
        {
            var dir = RandOnUnitSphere();
            var clusterNoise = _starsClusteringAmplitude * _starsClusteringNoise.GetNoise3Dv(dir);
            dir += Vector3.One * clusterNoise;
            dir = dir.Normalized();
            var (vertsI, uvsI, trisI) = GenerateCircle(dir, vertices.Count);
            vertices.AddRange(vertsI);
            triangles.AddRange(trisI);
            uvs.AddRange(uvsI);
            var colData = new Array<Color>();
            colData.Resize(vertsI.Count);
            colData.Fill(new Color(Mathf.Abs(clusterNoise), 0f, 0f));
            cols.AddRange(colData);
        }
        arrays[(int)Mesh.ArrayType.Vertex] = vertices.ToArray();
        arrays[(int)Mesh.ArrayType.Index] = triangles.ToArray();
        arrays[(int)Mesh.ArrayType.TexUV] = uvs.ToArray();
        arrays[(int)Mesh.ArrayType.Color] = cols.ToArray();
        // 创建网格
        mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
        CallDeferred(nameof(SetMesh), mesh);
    }

    private void SetMesh(Mesh mesh)
    {
        GetNode<MeshInstance3D>("StarsMesh").Mesh = mesh;
        GetNode<MeshInstance3D>("StarsMesh").MaterialOverride = _material.Duplicate() as ShaderMaterial;
    }

    private (Array<Vector3> verts, Array<Vector2> uvs, Array<int> tris) GenerateCircle(Vector3 dir, int indexOffset)
    {
        var size = _rng.RandfRange(_sizeMinMax.X, _sizeMinMax.Y);
        var brightness = _rng.RandfRange(_minBrightness, _maxBrightness);
        var spectrumT = _rng.Randf();

        var axisA = dir.Cross(Vector3.Up).Normalized();
        if (axisA == Vector3.Zero)
            axisA = dir.Cross(Vector3.Forward).Normalized();
        var axisB = dir.Cross(axisA);
        var center = dir * _distance;

        var verts = new Array<Vector3>();
        verts.Resize(_numVertsPerStar + 1);
        var uvs = new Array<Vector2>();
        uvs.Resize(_numVertsPerStar + 1);
        var tris = new Array<int>();
        tris.Resize(_numVertsPerStar * 3);

        verts[0] = center;
        uvs[0] = new Vector2(brightness, spectrumT);

        for (var vertIndex = 0; vertIndex < _numVertsPerStar; vertIndex++)
        {
            var currAngle = 2f * Mathf.Pi * vertIndex / _numVertsPerStar;
            var vert = center + (axisA * Mathf.Sin(currAngle) + axisB * Mathf.Cos(currAngle)) * size;
            verts[vertIndex + 1] = vert;
            uvs[vertIndex + 1] = new Vector2(0, spectrumT);
            if (vertIndex < _numVertsPerStar)
            {
                tris[vertIndex * 3] = indexOffset;
                tris[vertIndex * 3 + 1] = vertIndex + 1 + indexOffset;
                tris[vertIndex * 3 + 2] = (vertIndex + 1) % _numVertsPerStar + 1 + indexOffset;
            }
        }

        return (verts, uvs, tris);
    }

    private Vector3 RandOnUnitSphere()
    {
        var x = _rng.RandfRange(-1f, 1f);
        var y = _rng.RandfRange(-1f, 1f);
        var z = _rng.RandfRange(-1f, 1f);
        var dir = new Vector3(x, y, z).Normalized();
        if (dir.Length() == 0f)
            dir = Vector3.Left;
        return dir;
    }
}