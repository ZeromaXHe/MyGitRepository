namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type CustomGravityRigidBodyFS() =
    inherit RigidBody3D()

    let mutable floatDelay = 0f

    abstract FloatToSleep: bool with get, set // 默认 false 
    
    override this._Ready() = this.GravityScale <- 0f

    override this._PhysicsProcess delta =
        let directReturn =
            if not this.FloatToSleep then
                false
            elif this.Sleeping then
                floatDelay <- 0f
                true
            elif this.LinearVelocity.LengthSquared() < 0.0001f then
                floatDelay <- floatDelay + float32 delta
                floatDelay >= 1f
            else
                floatDelay <- 0f
                false

        if not directReturn then
            this.ApplyForce <| this.Mass * CustomGravity.getGravity this.GlobalPosition
