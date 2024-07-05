using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using Godot;

namespace UnityHexPlanet
{
    [Tool]
    public partial class PerlinTerrainGenerator : BaseTerrainGenerator
    {
        [System.Serializable]
        public class ColorHeight
        {
            public Color Color;
            public float MaxHeight;
        }

        [Export(PropertyHint.Range, "1, 8")] public int Octaves = 1;
        [Export(PropertyHint.Range, "0, 1")] public float Persistence = 0.5f;
        [Export(PropertyHint.Range, "1, 10")] public float Lacunarity = 2;

        public float MinHeight;
        public float MaxHeight;
        public float NoiseScaling;
        public List<ColorHeight> ColorHeights;

        private static FastNoiseLite _perlinNoise;

        static PerlinTerrainGenerator()
        {
            _perlinNoise = new FastNoiseLite();
            _perlinNoise.NoiseType = FastNoiseLite.NoiseTypeEnum.Perlin;
        }

        public override void AfterTileCreation(HexTile newTile)
        {
            float height = Mathf.Floor(3 * (((MaxHeight - MinHeight) * GetNoise(newTile.Center.Normalized().X,
                newTile.Center.Normalized().Y, newTile.Center.Normalized().Z)) + MinHeight)) / 3.0f;
            newTile.Height = height;

            // for (int i = ColorHeights.Count - 1; i >= 0; i--)
            // {
            //     if (height < ColorHeights[i].MaxHeight)
            //     {
            //         newTile.Color = ColorHeights[i].Color;
            //     }
            // }
        }

        private float GetNoise(float x, float y, float z)
        {
            float value = 0.0f;
            float scale = NoiseScaling;
            float effect = 1.0f;
            for (int i = 0; i < Octaves; i++)
            {
                value += effect * PerlinNoise3D(scale * x, scale * y, scale * z);
                scale *= Lacunarity;
                effect *= (1 - Persistence);
            }

            return value;
        }

        private static float PerlinNoise3D(float x, float y, float z)
        {
            x += 15;
            y += 25;
            z += 35;
            float xy = _perlinNoise.GetNoise2D(x, y);
            float xz = _perlinNoise.GetNoise2D(x, z);
            float yz = _perlinNoise.GetNoise2D(y, z);
            float yx = _perlinNoise.GetNoise2D(y, x);
            float zx = _perlinNoise.GetNoise2D(z, x);
            float zy = _perlinNoise.GetNoise2D(z, y);
            return (xy + xz + yz + yx + zx + zy) / 6;
        }
    }
}