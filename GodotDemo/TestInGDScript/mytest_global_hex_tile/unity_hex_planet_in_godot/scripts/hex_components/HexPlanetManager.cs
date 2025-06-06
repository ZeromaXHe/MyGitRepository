using System.Collections;
using System.Collections.Generic;
using Godot;

namespace UnityHexPlanet
{
    [Tool]
    public partial class HexPlanetManager: Node3D
    {
        [Export] private bool _regenerate = false;

        public HexPlanet HexPlanet;
        private HexPlanet _prevHexPlanet;
        private Node3D _hexChunkRenders;

        public override void _Ready()
        {
            HexPlanet = GetNode<HexPlanet>("HexPlanet");
            _hexChunkRenders = GetNode<Node3D>("HexChunkRenders");

            UpdateRenderObjects();
        }

        public override void _Process(double delta)
        {
            if (_regenerate)
            {
                UpdateRenderObjects();
                _regenerate = false;
            }
        }

        // Called when the whole sphere must be regenerated
        public void UpdateRenderObjects()
        {
            // 删除所有子节点 Delete all children
            foreach (Node child in _hexChunkRenders.GetChildren())
            {
                child.QueueFree();
            }

            if (HexPlanet == null)
            {
                return;
            }

            HexPlanetHexGenerator.GeneratePlanetTilesAndChunks(HexPlanet);

            for (int i = 0; i < HexPlanet.Chunks.Count; i++)
            {
                HexChunkRenderer chunkGO = new HexChunkRenderer();
                chunkGO.Name = "Chunk " + i;
                chunkGO.Position = Vector3.Zero;
                // MeshFilter mf = chunkGO.AddComponent<MeshFilter>();
                // MeshCollider mc = chunkGO.AddComponent<MeshCollider>();
                //
                // MeshRenderer mr = chunkGO.AddComponent<MeshRenderer>();
                // mr.sharedMaterial = hexPlanet.chunkMaterial;
                chunkGO.SetHexChunk(HexPlanet, i);
                chunkGO.UpdateMesh();
                _hexChunkRenders.AddChild(chunkGO);

                // Set layer
                // int hexPlanetLayer = LayerMask.NameToLayer("HexPlanet");
                // if (hexPlanetLayer == -1)
                // {
                //     throw new UnassignedReferenceException("Layer \"HexPlanet\" must be created in the Layer Manager!");
                // }
                //
                // chunkGO.layer = hexPlanetLayer;
            }
        }

        // IEnumerator Destroy(GameObject go)
        // {
        //     yield return new WaitForSeconds(0.1f);
        //     DestroyImmediate(go);
        // }
    }
}