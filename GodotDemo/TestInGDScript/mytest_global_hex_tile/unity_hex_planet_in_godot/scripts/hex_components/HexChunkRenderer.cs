using Godot;

namespace UnityHexPlanet
{
    public partial class HexChunkRenderer: MeshInstance3D
    {
        public int RenderedChunkId;
        private HexPlanet _planet;
        private HexChunk _chunk;

        // private MeshRenderer _meshRenderer;
        // private MeshFilter _meshFilter;
        // private MeshCollider _meshCollider;

        public HexChunk GetHexChunk()
        {
            if (_chunk == null)
            {
                _chunk = _planet.GetChunk(RenderedChunkId);
            }

            return _chunk;
        }

        public void SetHexChunk(HexPlanet planet, int chunkId)
        {
            _planet = planet;
            RenderedChunkId = chunkId;
        }

        public void Start()
        {
            // _meshRenderer = GetComponent<MeshRenderer>();
            // _planet = GetComponentInParent<HexPlanetManager>().hexPlanet;
            _planet = (GetTree().GetFirstNodeInGroup("HexPlanetManager") as HexPlanetManager).HexPlanet;
            _planet.GetChunk(RenderedChunkId).OnChunkChange += OnChunkChange;
            UpdateMesh();
        }

        public void Update()
        {
            // if (Application.isPlaying)
            // {
                if (GetHexChunk().IsDirty)
                {
                    UpdateMesh();
                    GetHexChunk().IsDirty = false;
                }
            // }
        }

        public void OnChunkChange(HexTile changedTile)
        {
            _planet.GetChunk(changedTile.ChunkId).MakeDirty();
            foreach (HexTile nTile in changedTile.GetNeighbors())
            {
                if (changedTile.ChunkId != nTile.ChunkId)
                {
                    _planet.GetChunk(nTile.ChunkId).MakeDirty();
                }
            }
        }

        public void UpdateMesh()
        {
            // if (_meshFilter == null)
            // {
            //     _meshFilter = GetComponent<MeshFilter>();
            //     _meshCollider = GetComponent<MeshCollider>();
            // }

            Mesh newChunkMesh = GetHexChunk().GetMesh();
            Mesh = newChunkMesh;
            // _meshFilter.mesh = newChunkMesh;
            // _meshCollider.sharedMesh = newChunkMesh;
        }
    }
}