namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot

type DebugFS() =
    inherit Label()

    let mutable player = Unchecked.defaultof<PlayerFS>
    let mutable voxelWorld = Unchecked.defaultof<VoxelWorldFS>

    member this.VectorToStringAppropriateDigits(vector: Vector3) =
        let factors = [| 1000; 1000; 1000 |]

        for i in 0..2 do
            if Mathf.Abs vector[i] > 4096f then
                factors[i] <- factors[i] / 10

                if Mathf.Abs vector[i] > 65536f then
                    factors[i] <- factors[i] / 10

                    if Mathf.Abs vector[i] > 524288f then
                        factors[i] <- factors[i] / 10

        $"({Mathf.Round(vector.X * float32 factors[0]) / float32 factors[0]}, {Mathf.Round(vector.Y * float32 factors[1]) / float32 factors[1]}, {Mathf.Round(vector.Z * float32 factors[2]) / float32 factors[2]})"

    member this.CardinalStringFromRadians =
        function
        | angle when angle > Mathf.Tau * 3f / 8f -> "南"
        | angle when angle < -Mathf.Tau * 3f / 8f -> "南"
        | angle when angle > Mathf.Tau / 8f -> "西"
        | angle when angle < -Mathf.Tau / 8f -> "东"
        | _ -> "北"

    override this._Ready() =
        player <- this.GetNode<PlayerFS> "../Player"
        voxelWorld <- this.GetNode<VoxelWorldFS> "../VoxelWorld"

    override this._Process _ =
        if Input.IsActionJustPressed "debug" then
            this.Visible <- not this.Visible

        this.Text <-
            $"""位置: {this.VectorToStringAppropriateDigits player.Transform.Origin}
有效渲染距离: {voxelWorld.EffectiveRenderDistance}
朝向: {this.CardinalStringFromRadians <| player.Transform.Basis.GetEuler().Y}
内存: %3.0f{float32 (OS.GetStaticMemoryUsage()) / 1038576f} MiB
FPS: {Engine.GetFramesPerSecond()}
"""
