namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type MovingSphereFS() =
    inherit CsgSphere3D()

    let mutable ready = false

    let mutable velocity = Vector3.Zero

    abstract MaxSpeed: float32 with get, set
    abstract MaxAcceleration: float32 with get, set
    abstract AllowedArea: Rect2 with get, set
    abstract Bounciness: float32 with get, set

    override this._Ready() =

        ready <- true

    override this._Process(delta) =
        if ready then
            let playerInput = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down")
            let desiredVelocity = Vector3(playerInput.X, 0f, playerInput.Y) * this.MaxSpeed
            let maxSpeedChange = this.MaxAcceleration * float32 delta
            velocity.X <- Mathf.MoveToward(velocity.X, desiredVelocity.X, maxSpeedChange)
            velocity.Z <- Mathf.MoveToward(velocity.Z, desiredVelocity.Z, maxSpeedChange)
            let displacement = velocity * float32 delta
            let mutable newPosition = this.Position + displacement

            if newPosition.X < this.AllowedArea.Position.X then
                newPosition.X <- this.AllowedArea.Position.X
                velocity.X <- -velocity.X * this.Bounciness
            elif newPosition.X > this.AllowedArea.End.X then
                newPosition.X <- this.AllowedArea.End.X
                velocity.X <- -velocity.X * this.Bounciness

            if newPosition.Z < this.AllowedArea.Position.Y then
                newPosition.Z <- this.AllowedArea.Position.Y
                velocity.Z <- -velocity.Z * this.Bounciness
            elif newPosition.Z > this.AllowedArea.End.Y then
                newPosition.Z <- this.AllowedArea.End.Y
                velocity.Z <- -velocity.Z * this.Bounciness

            this.Position <- newPosition
