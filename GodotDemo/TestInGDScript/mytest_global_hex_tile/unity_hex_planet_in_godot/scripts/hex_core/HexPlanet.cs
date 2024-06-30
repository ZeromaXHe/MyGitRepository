using System.Collections.Generic;
using Godot;

namespace UnityHexPlanet {
    [System.Serializable]
    public class HexPlanet
    {
        public float radius;
        [Export(PropertyHint.Range, "0,7")]
        public int subdivisions;
        [Export(PropertyHint.Range, "0,6")]
        public int chunkSubdivisions;

        public Material chunkMaterial;

        public BaseTerrainGenerator terrainGenerator;

        public List<HexTile> tiles;
        public List<HexChunk> chunks;

        public HexTile GetTile(int id) {
            return tiles[id];
        }

        public HexChunk GetChunk(int id) {
            return chunks[id];
        }

        public void OnBeforeSerialize() { }

        public void OnAfterDeserialize()
        {
            foreach (HexTile tile in tiles)
            {
                tile.Planet = this;
            }
            foreach (HexChunk chunk in chunks)
            {
                chunk.Planet = this;
                chunk.SetupEvents();
            }
        }

    }
}