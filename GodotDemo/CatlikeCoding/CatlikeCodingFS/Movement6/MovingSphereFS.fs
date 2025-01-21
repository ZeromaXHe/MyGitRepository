namespace CatlikeCodingFS.Movement6

open Godot

[<AbstractClass>]
type MovingSphereFS() =
    inherit RigidBody3D()

    let mutable ready = false

    let mutable velocity = Vector3.Zero
    let mutable desiredVelocity = Vector3.Zero
    let mutable desiredJump = false
    let mutable jumpPhase = 0
    let mutable groundContactCount = 0
    let mutable preGroundContactCount = 0
    let onGround () = groundContactCount > 0
    let mutable minGroudDotProduct = 0f
    let mutable contactNormal = Vector3.Zero

    abstract MaxSpeed: float32 with get, set
    abstract MaxAcceleration: float32 with get, set
    abstract MaxAirAcceleration: float32 with get, set
    abstract JumpHeight: float32 with get, set
    abstract MaxAirJumps: int with get, set
    abstract MaxGroundAngle: float32 with get, set

    member this.UpdateState() =
        velocity <- this.LinearVelocity

        if onGround () then
            jumpPhase <- 0

            if groundContactCount > 1 then
                contactNormal <- contactNormal.Normalized()
        else
            contactNormal <- Vector3.Up

    member this.Jump() =
        if onGround () || jumpPhase < this.MaxAirJumps then
            jumpPhase <- jumpPhase + 1
            let mutable jumpSpeed = Mathf.Sqrt(-2f * this.GetGravity().Y * this.JumpHeight)
            let alignedSpeed = velocity.Dot(contactNormal)

            if alignedSpeed > 0f then
                jumpSpeed <- Mathf.Max(jumpSpeed - alignedSpeed, 0f)

            velocity <- velocity + contactNormal * jumpSpeed

    // member this.EvaluateCollision() =
    //     // CharacterBody3D 用的
    //     for i in 0 .. this.GetSlideCollisionCount() - 1 do
    //         let collision = this.GetSlideCollision(i)
    //         let normal = collision.GetNormal()
    //         if normal.Y >= minGroudDotProduct then
    //             onGround <- true
    //             contactNormal <- normal

    member this.ProjectOnContactPlane(vector: Vector3) =
        vector - contactNormal * vector.Dot(contactNormal)

    member this.AdjustVelocity delta =
        let xAxis = (this.ProjectOnContactPlane Vector3.Right).Normalized()
        let zAxis = (this.ProjectOnContactPlane Vector3.Back).Normalized()
        let currentX = velocity.Dot xAxis
        let currentZ = velocity.Dot zAxis

        let acceleration =
            if onGround () then
                this.MaxAcceleration
            else
                this.MaxAirAcceleration

        let maxSpeedChange = acceleration * delta
        let newX = Mathf.MoveToward(currentX, desiredVelocity.X, maxSpeedChange)
        let newZ = Mathf.MoveToward(currentZ, desiredVelocity.Z, maxSpeedChange)
        velocity <- velocity + xAxis * (newX - currentX) + zAxis * (newZ - currentZ)

    member this.OnValidate() =
        minGroudDotProduct <- Mathf.Cos(Mathf.DegToRad this.MaxGroundAngle)

    member this.ClearState() =
        preGroundContactCount <- groundContactCount
        groundContactCount <- 0
        contactNormal <- Vector3.Zero

    member this.Sphere = this.GetNode<CsgSphere3D> "Sphere"

    override this._Ready() = ready <- true

    override this._Process(delta) =
        if ready then
            let playerInput = Input.GetVector("ui_left", "ui_right", "ui_up", "ui_down")
            desiredVelocity <- Vector3(playerInput.X, 0f, playerInput.Y) * this.MaxSpeed
            desiredJump <- desiredJump || Input.IsActionJustPressed "Jump"

            (this.Sphere.Material :?> StandardMaterial3D).AlbedoColor <-
                Colors.White * float32 preGroundContactCount * 0.25f

    override this._PhysicsProcess(delta) =
        // onGround <- this.IsOnFloor() // CharacterBody3D 用的
        // this.EvaluateCollision() // CharacterBody3D 用的
        this.UpdateState()
        this.AdjustVelocity <| float32 delta
        // 重力
        // velocity <- velocity + this.GetGravity() * float32 delta // CharacterBody3D 用的

        if desiredJump then
            desiredJump <- false
            this.Jump()

        this.LinearVelocity <- velocity

        this.ClearState()
    // this.MoveAndSlide() |> ignore // CharacterBody3D 用的

    override this._IntegrateForces(state) =
        for i in 0 .. state.GetContactCount() - 1 do
            let normal = state.GetContactLocalNormal(i)

            if normal.Y >= minGroudDotProduct then
                groundContactCount <- groundContactCount + 1
                contactNormal <- contactNormal + normal
