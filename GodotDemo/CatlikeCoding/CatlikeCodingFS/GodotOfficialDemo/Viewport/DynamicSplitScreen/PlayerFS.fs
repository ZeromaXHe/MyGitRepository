namespace CatlikeCodingFS.GodotOfficialDemo.Viewport.DynamicSplitScreen

open Godot

[<AbstractClass>]
type PlayerFS() =
    inherit CharacterBody3D()
    // 移动玩家
    abstract PlayerId: int with get, set
    abstract WalkSpeed: float32 with get, set

    override this._PhysicsProcess _ =
        let moveDirection =
            if this.PlayerId = 1 then
                Input.GetVector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
            else
                Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down")

        let mutable velocity = this.Velocity
        velocity.X <- velocity.X + moveDirection.X * this.WalkSpeed
        velocity.Z <- velocity.Z + moveDirection.Y * this.WalkSpeed
        // 应用摩擦力
        velocity <- velocity * 0.9f
        this.Velocity <- velocity
        this.MoveAndSlide() |> ignore
