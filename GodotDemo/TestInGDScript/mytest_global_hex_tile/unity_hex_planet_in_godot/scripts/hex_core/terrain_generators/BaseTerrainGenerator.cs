using System.Collections.Generic;
using Godot;

namespace UnityHexPlanet {

    [System.Serializable]
    public partial class BaseTerrainGenerator: Node3D
    {
        public virtual HexTile CreateHexTile(int id, HexPlanet planet, Vector3 centerPosition, List<Vector3> verts) {
            return new HexTile(id, planet, centerPosition, verts);
        }

        public virtual void AfterTileCreation(HexTile newTile) { }
    }
}