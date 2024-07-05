using System;
using System.Collections.Generic;
using Godot;

namespace UnityHexPlanet {

    [System.Serializable]
    public partial class RandomTerrainGenerator : BaseTerrainGenerator
    {

        public float minHeight;
        public float maxHeight;

        public List<Color> colors;

        public override void AfterTileCreation(HexTile newTile) {
            newTile.Height = (float)GD.RandRange(minHeight, maxHeight);
            newTile.Color = colors[(int)Mathf.Floor(GD.RandRange(0, colors.Count))];
        }
    }

}