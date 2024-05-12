using Godot;
using System;

public partial class Chunk : MeshInstance3D
{
    [Export(PropertyHint.Range, "20, 400, 1")]
    private int _terrainSize = 100;

    [Export(PropertyHint.Range, "1, 100, 1")]
    private int _resolution = 30;

    [Export] public int TerrainMaxHeight = 5;

    private int[] _chunkLods = { 5, 20, 50, 80 };
    private Vector2 _positionCoord = new();
    private const float CenterOffset = 0.5f;
    private bool _setCollision = false;

    public void GenerateTerrain(FastNoiseLite noise, Vector2 coords, float size, bool initiallyVisible)
    {
        _terrainSize = (int)size;
        _positionCoord = coords * size;
        var surfaceTool = new SurfaceTool();
        surfaceTool.Begin(Mesh.PrimitiveType.Triangles);
        for (int z = 0; z < _resolution + 1; z++)
        {
            for (int x = 0; x < _resolution + 1; x++)
            {
                var percent = new Vector2(x, z) / _resolution;
                var pointOnMesh = new Vector3(percent.X - CenterOffset, 0, percent.Y - CenterOffset);
                var vertex = pointOnMesh * _terrainSize;
                vertex.Y = noise.GetNoise2D(Position.X + vertex.X, Position.Z + vertex.Z) * TerrainMaxHeight;

                var uv = new Vector2(percent.X, percent.Y);
                surfaceTool.SetUV(uv);
                surfaceTool.AddVertex(vertex);
            }
        }

        var vert = 0;
        for (int z = 0; z < _resolution; z++)
        {
            for (int x = 0; x < _resolution; x++)
            {
                surfaceTool.AddIndex(vert + 0);
                surfaceTool.AddIndex(vert + 1);
                surfaceTool.AddIndex(vert + _resolution + 1);
                surfaceTool.AddIndex(vert + _resolution + 1);
                surfaceTool.AddIndex(vert + 1);
                surfaceTool.AddIndex(vert + _resolution + 2);
                vert++;
            }

            vert++;
        }

        surfaceTool.GenerateNormals();
        var arrayMesh = surfaceTool.Commit();
        Mesh = arrayMesh;

        if (_setCollision)
        {
            CreateCollision();
        }

        SetChunkVisible(initiallyVisible);
    }


    public void UpdateChunk(Vector2 viewPos, float maxViewDis)
    {
        var viewerDistance = _positionCoord.DistanceTo(viewPos);
        var isVisible = viewerDistance <= maxViewDis;
        SetChunkVisible(isVisible);
    }

    public bool UpdateLod(Vector2 viewPos)
    {
        var viewerDistance = _positionCoord.DistanceTo(viewPos);
        var updateTerrain = false;
        var newLod = 0;
        if (viewerDistance > 1000)
        {
            newLod = _chunkLods[0];
        }
        else if (viewerDistance >= 900)
        {
            newLod = _chunkLods[1];
        }
        else if (viewerDistance >= 500)
        {
            newLod = _chunkLods[2];
        }
        else
        {
            newLod = _chunkLods[3];
            _setCollision = true;
        }

        if (_resolution != newLod)
        {
            _resolution = newLod;
            updateTerrain = true;
        }

        return updateTerrain;
    }

    public void SetChunkVisible(bool isVisible)
    {
        Visible = isVisible;
    }

    private void CreateCollision()
    {
        if (GetChildCount() > 0)
        {
            foreach (var child in GetChildren())
            {
                child.Free();
            }
        }

        CreateTrimeshCollision();
    }
}