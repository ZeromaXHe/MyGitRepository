using System.Collections;
using System.Collections.Generic;
using Godot;

namespace UnityHexPlanet
{
    public partial class HexPlanetManager: Node3D
    {
        public HexPlanet hexPlanet;
        private HexPlanet _prevHexPlanet;

        // Called when the whole sphere must be regenerated
        public void UpdateRenderObjects()
        {
            // Delete all children
            foreach (Node child in GetChildren())
            {
                child.QueueFree();
            }

            if (hexPlanet == null)
            {
                return;
            }

            HexPlanetHexGenerator.GeneratePlanetTilesAndChunks(hexPlanet);

            for (int i = 0; i < hexPlanet.chunks.Count; i++)
            {
                MeshInstance3D chunkGO = new MeshInstance3D();
                chunkGO.Name = "Chunk " + i;
                AddChild(chunkGO);
                
                HexChunkRenderer hcr = new HexChunkRenderer();
                
                // MeshFilter mf = chunkGO.AddComponent<MeshFilter>();
                // MeshCollider mc = chunkGO.AddComponent<MeshCollider>();
                //
                // MeshRenderer mr = chunkGO.AddComponent<MeshRenderer>();
                // mr.sharedMaterial = hexPlanet.chunkMaterial;
                hcr.SetHexChunk(hexPlanet, i);
                hcr.UpdateMesh();

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