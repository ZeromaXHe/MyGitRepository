using Godot;
using Godot.Collections;
using ProceduralPlanet.Scripts.Planet.Settings;
using ProceduralPlanet.Scripts.Planet.Shape.Mesh;
using ProceduralPlanet.Scripts.Utils;

namespace ProceduralPlanet.Scripts.Planet;

[Tool]
public partial class CelestialBodyGenerator : Node3D
{
    [Export] public bool AllowGenerate = false;
    private bool _isOcean = false;

    [Export]
    public bool IsOcean
    {
        get => _isOcean;
        set
        {
            _isOcean = value;
            OnShapeDataChanged();
        }
    }

    public enum PreviewModeEnum
    {
        LOD0,
        LOD1,
        LOD2,
        CollisionRes
    }

    private ResolutionSettings _resolutionSettings;

    [Export]
    public ResolutionSettings ResolutionSettings
    {
        get => _resolutionSettings;
        set
        {
            _resolutionSettings = value;
            _resolutionSettings.ResourceName = "分辨率设置";
            _resolutionSettings.Changed += OnResolutionDataChanged;
        }
    }

    private PreviewModeEnum _previewMode = PreviewModeEnum.LOD2;

    [Export]
    public PreviewModeEnum PreviewMode
    {
        get => _previewMode;
        set
        {
            _previewMode = value;
            OnShapeDataChanged();
        }
    }

    [Export] public Camera3D Camera;
    private CelestialBodySettings _body;

    [Export]
    public CelestialBodySettings Body
    {
        get => _body;
        set
        {
            _body = value;
            _body.ResourceName = "星体设置";
            _body.ShapeChanged += OnShapeDataChanged;
            _body.ShadeChanged += OnShadeDataChanged;
        }
    }

    private bool _debugDoubleUpdate = true;
    private int _debugNumUpdates;
    private ArrayMesh _previewMesh = new();
    private ArrayMesh _collisionMesh;
    private Array<ArrayMesh> _lodMeshes = [];
    private bool _shapeSettingsUpdated = true;
    private bool _shadingNoiseSettingsUpdated = true;
    private Vector2 _heightMinMax;
    private int _activeLodIndex = -1;
    private Dictionary<int, PlanetSphereMesh> _sphereGenerators = new();

    private bool _readyToGenerate = false;

    public override void _Ready()
    {
        _readyToGenerate = true;
        if (!Engine.IsEditorHint())
            HandleGameModeGeneration();
    }

    private void OnShapeDataChanged()
    {
        if (_readyToGenerate)
            _shapeSettingsUpdated = true;
    }

    private void OnShadeDataChanged()
    {
        if (_readyToGenerate)
            _shadingNoiseSettingsUpdated = true;
    }

    private void OnResolutionDataChanged()
    {
        if (_readyToGenerate)
            _resolutionSettings?.ClampResolutions();
    }

    public override void _Process(double delta)
    {
        if (!_readyToGenerate)
            return;

        if (Engine.IsEditorHint())
        {
            HandleEditModeGeneration();
        }
        else
        {
            var distanceToCamera = GlobalPosition.DistanceTo(Camera.GlobalPosition);
            if (_lodMeshes.Count <= 0)
                return;
            for (var i = 0; i < _resolutionSettings.LodParameters.Length; i++)
            {
                var lod = _resolutionSettings.LodParameters[i];
                if (!(distanceToCamera < BodyScale() + lod.MinDistance))
                    continue;
                SetLod(i);
                // 如果在高分辨率距离内，不要挑选低分辨率
                break;
            }
        }
    }

    private void HandleGameModeGeneration()
    {
        if (CanGenerateMesh())
        {
            // 生成 LOD 网格
            _lodMeshes.Clear();
            _lodMeshes.Resize(_resolutionSettings.NumLodLevels());
            for (var i = 0; i < _lodMeshes.Count; i++)
                _lodMeshes[i] = new ArrayMesh();
            for (var i = 0; i < _lodMeshes.Count; i++)
            {
                if (_lodMeshes[i] == null) // 为啥这样写？
                    _lodMeshes[i] = new ArrayMesh();
                else
                    _lodMeshes[i].ClearSurfaces();
                var lodTerrainHeightMinMax =
                    GenerateTerrainMesh(_lodMeshes[i], _resolutionSettings.GetLodResolution(i));
                if (i == 0)
                    _heightMinMax = lodTerrainHeightMinMax;
            }

            // 生成碰撞网格
            _collisionMesh = new ArrayMesh();
            GenerateCollisionMesh(_resolutionSettings.Collider);

            if (_body.Shading != null)
            {
                // 创建地貌渲染器并设置着色属性为受检查实例材料
                var meshIns = GetNode<MeshInstance3D>("MeshInstance3D");
                meshIns.MaterialOverride = _body.Shading.TerrainMaterial.Duplicate() as Material;
                _body.Shading.Initialize(_body.Shape);
                _body.Shading.SetTerrainProperties(meshIns.MaterialOverride as ShaderMaterial, _heightMinMax,
                    BodyScale());
            }

            SetLod(2);
        }
        else if (_isOcean)
        {
            // 生成 LOD 网格
            _lodMeshes.Clear();
            _lodMeshes.Resize(_resolutionSettings.NumLodLevels());
            for (var i = 0; i < _lodMeshes.Count; i++)
                _lodMeshes[i] = new ArrayMesh();
            for (var i = 0; i < _lodMeshes.Count; i++)
            {
                if (_lodMeshes[i] == null) // 为啥这样写？
                    _lodMeshes[i] = new ArrayMesh();
                else
                    _lodMeshes[i].ClearSurfaces();
                GenerateOceanMesh(_lodMeshes[i], _resolutionSettings.GetLodResolution(i));
            }

            // 生成碰撞网格
            _collisionMesh = new ArrayMesh();
            GenerateCollisionMesh(_resolutionSettings.Collider, true);
        }
    }

    // 处理在编辑器中创建天体
    // 这允许更新形状/着色设置
    private void HandleEditModeGeneration()
    {
        if (!AllowGenerate) return;
        if (CanGenerateMesh())
        {
            // 更新形状设置和着色设置
            if (_shapeSettingsUpdated)
            {
                _shadingNoiseSettingsUpdated = true;
                if (_previewMesh == null)
                    _previewMesh = new ArrayMesh();
                else
                    _previewMesh.ClearSurfaces();
                _heightMinMax = GenerateTerrainMesh(_previewMesh, PickTerrainRes());
                Callable.From(() => SetMesh(_previewMesh)).CallDeferred();
            }

            // 如果只有着色噪声修改了，从形状到保存时间分别地更新它
            if (_shadingNoiseSettingsUpdated && _body.Shading != null)
            {
                _shadingNoiseSettingsUpdated = false;
                // 创建地貌渲染器并设置着色属性为受检查实例材料
                var meshIns = GetNode<MeshInstance3D>("MeshInstance3D");
                meshIns.MaterialOverride = _body.Shading.TerrainMaterial.Duplicate() as Material;
                _body.Shading.Initialize(_body.Shape);
                _body.Shading.SetTerrainProperties(meshIns.MaterialOverride as ShaderMaterial, _heightMinMax,
                    BodyScale());

                if (!_shapeSettingsUpdated)
                {
                    var arrays = _previewMesh.SurfaceGetArrays(0);
                    // 着色噪声数据
                    _body.Shading.Initialize(_body.Shape);
                    var shadingData =
                        _body.Shading.GenerateShadingData(arrays[(int)Mesh.ArrayType.Vertex].AsVector3Array());
                    var uv1 = shadingData[0];
                    var uv2 = shadingData[1];
                    arrays[(int)Mesh.ArrayType.TexUV] = uv1;
                    arrays[(int)Mesh.ArrayType.TexUV2] = uv2;
                    _previewMesh.ClearSurfaces();
                    _previewMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
                    Callable.From(() => SetMesh(_previewMesh)).CallDeferred();
                }
            }

            _shapeSettingsUpdated = false;
            _shadingNoiseSettingsUpdated = false;
        }
        else if (_isOcean)
        {
            if (_shapeSettingsUpdated)
            {
                _shapeSettingsUpdated = false;
                _shadingNoiseSettingsUpdated = false;
                if (_previewMesh == null)
                    _previewMesh = new ArrayMesh();
                else
                    _previewMesh.ClearSurfaces();
                GenerateOceanMesh(_previewMesh, PickTerrainRes());
                Callable.From(() => SetMesh(_previewMesh)).CallDeferred();
            }
        }
    }

    private bool CanGenerateMesh() => _body?.Shape?.HeightMapCompute != null;

    private void SetLod(int lodIndex)
    {
        if (lodIndex != _activeLodIndex)
        {
            _activeLodIndex = lodIndex;
            Callable.From(() => SetMesh(_lodMeshes[lodIndex])).CallDeferred();
        }
    }

    private void SetMesh(Mesh mesh) => GetNode<MeshInstance3D>("MeshInstance3D").Mesh = mesh;

    private void SetCollisionMesh(Mesh mesh)
    {
        var shape = mesh.CreateTrimeshShape();
        GetNode<CollisionShape3D>("CollisionShape3D").Shape = shape;
    }

    // 基于 Shape3D 对象生成的受检高度，创建地貌网格
    // 来自着色对象的着色数据被存储在网格 UV 中
    // 返回 min/max 地貌高度
    private Vector2 GenerateTerrainMesh(ArrayMesh mesh, int resolution)
    {
        var arrays = new Array();
        arrays.Resize((int)Mesh.ArrayType.Max);
        var (vertices, triangles) = CreateSphereVertsAndTris(resolution);
        var edgeLength = (vertices[triangles[0]] - vertices[triangles[1]]).Length();
        // 设置高度
        var heights = _body.Shape.CalculateHeights(vertices);
        // 扰动顶点来给地貌一个更不完美的光滑的外观
        if (_body.Shape.PerturbVertices && _body.Shape.PerturbCompute != null)
        {
            var perturb = _body.Shape.PerturbCompute;
            var maxPerturbStrength = _body.Shape.PerturbStrength * edgeLength / 2f;
            var pertData = perturb.Run(vertices, maxPerturbStrength);
            vertices = pertData;
        }

        // 计算地貌 min/max 高度和设置顶点高度
        var minHeight = float.PositiveInfinity;
        var maxHeight = float.NegativeInfinity;
        for (var i = 0; i < heights.Length; i++)
        {
            var height = heights[i];
            vertices[i] *= height;
            minHeight = Mathf.Min(minHeight, height);
            maxHeight = Mathf.Max(maxHeight, height);
        }

        arrays[(int)Mesh.ArrayType.Vertex] = vertices;
        arrays[(int)Mesh.ArrayType.Index] = triangles;
        var normals = MathUtils.RecalculateNormals(vertices, triangles);
        arrays[(int)Mesh.ArrayType.Normal] = normals;
        // 着色噪声数据
        if (_body.Shading != null)
        {
            _body.Shading.Initialize(_body.Shape);
            var shadingData = _body.Shading.GenerateShadingData(vertices);
            var uv1 = shadingData[0];
            var uv2 = shadingData[1];
            arrays[(int)Mesh.ArrayType.TexUV] = uv1;
            arrays[(int)Mesh.ArrayType.TexUV2] = uv2;
        }

        // 创建粗略的切线（向量垂直于表面法线）
        // 这是需要的（即使法线贴图通过三平面（triplanar）完成）
        // 因为表面着色器在切线空间需要法线
        var crudeTangents = new float[vertices.Length * 4];
        for (var i = 0; i < vertices.Length; i++)
        {
            var normal = normals[i];
            crudeTangents[i * 4] = -normal.Z;
            crudeTangents[i * 4 + 1] = 0f;
            crudeTangents[i * 4 + 2] = normal.X;
            crudeTangents[i * 4 + 3] = 1f;
        }

        arrays[(int)Mesh.ArrayType.Tangent] = crudeTangents;
        // 创建网格
        mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
        return new Vector2(minHeight, maxHeight);
    }

    private void GenerateCollisionMesh(int resolution, bool isOcean = false)
    {
        var arrays = new Array();
        arrays.Resize((int)Mesh.ArrayType.Max);
        var (vertices, triangles) = CreateSphereVertsAndTris(resolution);
        if (!_isOcean)
        {
            var edgeLength = (vertices[triangles[0]] - vertices[triangles[1]]).Length();
            // 设置高度
            var heights = _body.Shape.CalculateHeights(vertices);
            // 扰动顶点来给地貌一个更不完美的光滑的外观
            if (_body.Shape.PerturbVertices && _body.Shape.PerturbCompute != null)
            {
                var perturb = _body.Shape.PerturbCompute;
                var maxPerturbStrength = _body.Shape.PerturbStrength * edgeLength / 2f;
                var pertData = perturb.Run(vertices, maxPerturbStrength);
                vertices = pertData;
            }

            for (var i = 0; i < heights.Length; i++)
                vertices[i] *= heights[i];
        }

        arrays[(int)Mesh.ArrayType.Vertex] = vertices;
        arrays[(int)Mesh.ArrayType.Index] = triangles;
        // 创建网格
        _collisionMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
        Callable.From(() => SetCollisionMesh(_collisionMesh)).CallDeferred();
    }

    private void GenerateOceanMesh(ArrayMesh mesh, int resolution)
    {
        var arrays = new Array();
        arrays.Resize((int)Mesh.ArrayType.Max);
        var (vertices, triangles) = CreateSphereVertsAndTris(resolution);

        arrays[(int)Mesh.ArrayType.Vertex] = vertices;
        arrays[(int)Mesh.ArrayType.Index] = triangles;
        var normals = MathUtils.RecalculateNormals(vertices, triangles);
        arrays[(int)Mesh.ArrayType.Normal] = normals;
        // 创建网格
        mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
    }

    private int PickTerrainRes()
    {
        if (Engine.IsEditorHint())
        {
            if (_previewMode == PreviewModeEnum.LOD0 && _resolutionSettings.NumLodLevels() > 0)
                return _resolutionSettings.LodParameters[0].Resolution;
            if (_previewMode == PreviewModeEnum.LOD1 && _resolutionSettings.NumLodLevels() > 1)
                return _resolutionSettings.LodParameters[1].Resolution;
            if (_previewMode == PreviewModeEnum.LOD2 && _resolutionSettings.NumLodLevels() > 2)
                return _resolutionSettings.LodParameters[2].Resolution;
            if (_previewMode == PreviewModeEnum.CollisionRes)
                return _resolutionSettings.Collider;
        }

        return 0;
    }

    public float GetOceanRadius() => _body.Shading.HasOcean ? UnscaledOceanRadius() * BodyScale() : 0f;
    private float UnscaledOceanRadius() => Mathf.Lerp(_heightMinMax.X, 1f, _body.Shading.OceanLevel);
    public float BodyScale() => Transform.Basis.X.Length(); // 星体半径由天体类决定，来设置生成器对象（这个对象）的本地缩放

    private Vector3 PointOnPlanet(Vector3 dirFromOrigin)
    {
        var vertex = new[] { dirFromOrigin.Normalized() };
        var heights = _body.Shape.CalculateHeights(vertex);
        return dirFromOrigin * heights[0] * BodyScale();
    }

    // 生成球体（或如果已经生成则重用）并返回一个 vertices 和 triangles 的拷贝
    private (Vector3[] vertices, int[] triangles) CreateSphereVertsAndTris(int resolution)
    {
        if (!_sphereGenerators.ContainsKey(resolution))
            _sphereGenerators[resolution] = new PlanetSphereMesh(resolution);
        var generator = _sphereGenerators[resolution];
        var vertices = generator.Vertices.ToArray();
        var triangles = generator.Triangles.ToArray();
        return (vertices, triangles);
    }
}