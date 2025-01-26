namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type EnvironmentFS() =
    inherit WorldEnvironment()

    let mutable voxelWorld = Unchecked.defaultof<VoxelWorldFS>

    override this._Ready() =
        voxelWorld <- this.GetNode<VoxelWorldFS> "../VoxelWorld"

    override this._Process(delta) =
        this.Environment.FogEnabled <- SettingsFS.Instance.FogEnabled

        let targetDistance =
            Mathf.Clamp(voxelWorld.EffectiveRenderDistance, 2, voxelWorld.RenderDistance - 1)
            * ChunkFS.ChunkSize

        let rate = float32 delta * 4f

        SettingsFS.Instance.FogDistance <-
            Mathf.MoveToward(SettingsFS.Instance.FogDistance, float32 targetDistance, rate)

        this.Environment.FogDensity <- 0.5f / SettingsFS.Instance.FogDistance
