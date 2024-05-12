using Godot;
using System;
using System.Linq;
using Godot.Collections;
using Array = Godot.Collections.Array;

public partial class InfiniteTerrain : Node3D
{
    [Export] private int _chunkSize = 400;
    [Export] private int _terrainHeight = 20;
    [Export] private int _viewDistance = 4000;
    [Export] private Viewer _viewer;
    [Export] private PackedScene _chunkMeshScene;
    [Export] private bool _showWireFrame = false;

    private Vector2 _viewerPosition = new();
    private Dictionary _terrainChunks = new();
    private int _chunkVisible = 0;
    private Array<Chunk> _lastVisibleChunks = new();

    [Export] private FastNoiseLite _noise;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        _chunkVisible = Mathf.RoundToInt(_viewDistance / _chunkSize);
        if (_showWireFrame)
        {
            SetWireFrame();
        }

        UpdateVisibleChunk();
    }

    private void UpdateVisibleChunk()
    {
        foreach (var chunk in _lastVisibleChunks)
        {
            chunk.SetChunkVisible(false);
        }

        _lastVisibleChunks.Clear();

        var currentX = Mathf.RoundToInt(_viewerPosition.X / _chunkSize);
        var currentY = Mathf.RoundToInt(_viewerPosition.Y / _chunkSize);

        for (int yOffset = -_chunkVisible; yOffset < _chunkVisible; yOffset++)
        {
            for (int xOffset = -_chunkVisible; xOffset < _chunkVisible; xOffset++)
            {
                var viewChunkCoord = new Vector2(currentX - xOffset, currentY - yOffset);
                if (_terrainChunks.ContainsKey(viewChunkCoord))
                {
                    // 从 GDScript 的字典里拿出来要还原类型的话，得 As<> 这样处理
                    var chunk = _terrainChunks[viewChunkCoord].As<Chunk>();
                    chunk.UpdateChunk(_viewerPosition, _viewDistance);
                    if (chunk.UpdateLod(_viewerPosition))
                    {
                        chunk.GenerateTerrain(_noise, viewChunkCoord, _chunkSize, true);
                    }

                    if (chunk.Visible)
                    {
                        _lastVisibleChunks.Add(chunk);
                    }
                }
                else
                {
                    var chunk = _chunkMeshScene.Instantiate() as Chunk;
                    AddChild(chunk);
                    chunk.TerrainMaxHeight = _terrainHeight;
                    var pos = viewChunkCoord * _chunkSize;
                    var worldPosition = new Vector3(pos.X, 0, pos.Y);
                    chunk.GlobalPosition = worldPosition;
                    chunk.GenerateTerrain(_noise, viewChunkCoord, _chunkSize, false);
                    _terrainChunks[viewChunkCoord] = chunk;
                }
            }
        }
    }

    private void SetWireFrame()
    {
        RenderingServer.SetDebugGenerateWireframes(true);
        GetViewport().DebugDraw = Viewport.DebugDrawEnum.Wireframe;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(double delta)
    {
        _viewerPosition.X = _viewer.GlobalPosition.X;
        _viewerPosition.Y = _viewer.GlobalPosition.Z;
        UpdateVisibleChunk();
    }
}