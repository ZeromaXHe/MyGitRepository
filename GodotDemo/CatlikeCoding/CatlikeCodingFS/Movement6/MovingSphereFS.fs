namespace CatlikeCodingFS.Movement6

open Godot
open Godot.Collections

[<AbstractClass>]
type MovingSphereFS() =
    inherit RigidBody3D()

    let mutable ready = false

    let mutable velocity = Vector3.Zero
    let mutable desiredVelocity = Vector3.Zero
    let mutable desiredJump = false
    let mutable jumpPhase = 0
    let mutable groundContactCount = 0
    let onGround () = groundContactCount > 0
    let mutable steepContactCount = 0
    let onSteep () = steepContactCount > 0
    let mutable minGroudDotProduct = 0f
    let mutable contactNormal = Vector3.Zero
    let mutable steepNormal = Vector3.Zero
    let mutable stepsSinceLastGrounded = 0
    let mutable stepsSinceLastJump = 0

    let mutable upAxis = Vector3.Up
    let mutable rightAxis = Vector3.Right
    let mutable backAxis = Vector3.Back

    abstract PlayerInputSpace: Node3D with get, set
    abstract MaxSpeed: float32 with get, set
    abstract MaxAcceleration: float32 with get, set
    abstract MaxAirAcceleration: float32 with get, set
    abstract JumpHeight: float32 with get, set
    abstract MaxAirJumps: int with get, set
    abstract MaxGroundAngle: float32 with get, set
    abstract MaxSnapSpeed: float32 with get, set

    member this.Sphere = this.GetNode<CsgSphere3D> "Sphere"

    member private this.SnapToGround() =
        if stepsSinceLastGrounded > 1 || stepsSinceLastJump <= 2 then
            false
        else
            let speed = velocity.Length()

            if speed > this.MaxSnapSpeed then
                false
            else
                let spaceState = this.GetWorld3D().DirectSpaceState

                let query =
                    PhysicsRayQueryParameters3D.Create(
                        this.Position,
                        this.Position - upAxis,
                        exclude = Array<Rid>([| this.GetRid() |])
                    )

                let result = spaceState.IntersectRay query

                if result = null || result.Count < 1 then
                    false
                else
                    let normal = result["normal"].As<Vector3>()
                    let upDot = upAxis.Dot normal

                    if upDot < this.GetMinDot() then
                        false
                    else
                        groundContactCount <- 1
                        // GD.Print
                        //     $"vel: {velocity}, normal: {normal}, colPos: {this.RayCast.GetCollisionPoint()}, dist: {this.Position.DistanceTo <| this.RayCast.GetCollisionPoint()}"
                        contactNormal <- normal
                        let dot = velocity.Dot normal

                        if dot > 0f then
                            // BUG: 这种方式感觉有 BUG 啊……最后那几个偏置的斜坡（一边陡一边缓的）从缓坡上去的话就直接上天了……
                            velocity <- (velocity - normal * dot).Normalized() * speed

                        true

    member private this.CheckSteepContacts() =
        if steepContactCount > 1 then
            steepNormal <- steepNormal.Normalized()
            let upDot = upAxis.Dot steepNormal

            if upDot >= minGroudDotProduct then
                groundContactCount <- 1
                contactNormal <- steepNormal
                true
            else
                false
        else
            false

    member this.UpdateState() =
        stepsSinceLastGrounded <- stepsSinceLastGrounded + 1
        stepsSinceLastJump <- stepsSinceLastJump + 1
        velocity <- this.LinearVelocity

        if onGround () || this.SnapToGround() || this.CheckSteepContacts() then
            stepsSinceLastGrounded <- 0

            if stepsSinceLastJump > 1 then
                jumpPhase <- 0

            if groundContactCount > 1 then
                contactNormal <- contactNormal.Normalized()
        else
            contactNormal <- upAxis

    member this.Jump(gravity: Vector3) =
        let mutable jumpDirection =
            if onGround () then
                contactNormal
            elif onSteep () then
                jumpPhase <- 0
                steepNormal
            elif this.MaxAirJumps > 0 && jumpPhase <= this.MaxAirJumps then
                if jumpPhase = 0 then
                    jumpPhase <- 1

                contactNormal
            else
                Vector3.Zero

        if jumpDirection <> Vector3.Zero then
            stepsSinceLastJump <- 0
            jumpPhase <- jumpPhase + 1

            let mutable jumpSpeed = Mathf.Sqrt(2f * gravity.Length() * this.JumpHeight)
            // 我这里修改了一下，增加的 Vector3.Up 与投射在水平面上的方向向量长度成正二次比（90 度时达到 1）
            // 从而减少其他斜面上的起跳方向
            let verticalRatio = Vector2(jumpDirection.X, jumpDirection.Z).Length()
            jumpDirection <- (jumpDirection + verticalRatio * verticalRatio * upAxis).Normalized()

            let alignedSpeed = velocity.Dot(jumpDirection)

            if alignedSpeed > 0f then
                jumpSpeed <- Mathf.Max(jumpSpeed - alignedSpeed, 0f)

            velocity <- velocity + jumpDirection * jumpSpeed

    // member this.EvaluateCollision() =
    //     // CharacterBody3D 用的
    //     for i in 0 .. this.GetSlideCollisionCount() - 1 do
    //         let collision = this.GetSlideCollision(i)
    //         let normal = collision.GetNormal()
    //         if normal.Y >= minGroudDotProduct then
    //             onGround <- true
    //             contactNormal <- normal

    member this.ProjectDirectionOnPlane (direction: Vector3) (normal: Vector3) =
        (direction - normal * (direction.Dot normal)).Normalized()

    member this.AdjustVelocity delta =
        let xAxis = (this.ProjectDirectionOnPlane rightAxis contactNormal).Normalized()
        let zAxis = (this.ProjectDirectionOnPlane backAxis contactNormal).Normalized()
        let currentX = velocity.Dot xAxis
        let currentZ = velocity.Dot zAxis

        let acceleration =
            if onGround () then
                this.MaxAcceleration
            else
                this.MaxAirAcceleration

        let maxSpeedChange = acceleration * delta
        // GD.Print
        //     $"xAx: {xAxis}, zAx: {zAxis}, rAx: {rightAxis}, bAx: {backAxis}, cntNom: {contactNormal}, curX: {currentX}, curZ: {currentZ}, desVel: {desiredVelocity}, maxSpdChg: {maxSpeedChange}"
        let newX = Mathf.MoveToward(currentX, desiredVelocity.X, maxSpeedChange)
        let newZ = Mathf.MoveToward(currentZ, desiredVelocity.Z, maxSpeedChange)
        velocity <- velocity + xAxis * (newX - currentX) + zAxis * (newZ - currentZ)

    member this.OnValidate() =
        minGroudDotProduct <- Mathf.Cos(Mathf.DegToRad this.MaxGroundAngle)

    member this.ClearState() =
        (this.Sphere.Material :?> StandardMaterial3D).AlbedoColor <- Colors.White * float32 groundContactCount * 0.25f
        groundContactCount <- 0
        steepContactCount <- 0
        contactNormal <- Vector3.Zero
        steepNormal <- Vector3.Zero

    member this.GetMinDot() = minGroudDotProduct // TODO: Surface Contact 的 2 Stairs 楼梯逻辑没写

    override this._Ready() = ready <- true

    override this._Process(delta) =
        if ready then
            let playerInput = Input.GetVector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")

            if this.PlayerInputSpace <> null then
                let back = this.PlayerInputSpace.Quaternion * Vector3.Back // Godot 和 Unity 前后相反
                let right = this.PlayerInputSpace.Quaternion * Vector3.Right
                rightAxis <- this.ProjectDirectionOnPlane right upAxis
                backAxis <- this.ProjectDirectionOnPlane back upAxis
            else
                rightAxis <- this.ProjectDirectionOnPlane Vector3.Right upAxis
                backAxis <- this.ProjectDirectionOnPlane Vector3.Back upAxis

            desiredVelocity <- Vector3(playerInput.X, 0f, playerInput.Y) * this.MaxSpeed
            desiredJump <- desiredJump || Input.IsActionJustPressed "Jump"

    override this._PhysicsProcess(delta) =
        let gravity, upAx = CustomGravity.getGravityAndUpAxis this.GlobalPosition
        upAxis <- upAx
        // onGround <- this.IsOnFloor() // CharacterBody3D 用的
        // this.EvaluateCollision() // CharacterBody3D 用的
        this.UpdateState()
        this.AdjustVelocity <| float32 delta


        if desiredJump then
            desiredJump <- false
            this.Jump gravity

        velocity <- velocity + gravity * float32 delta
        // 重力
        // velocity <- velocity + this.GetGravity() * float32 delta // CharacterBody3D 用的
        this.LinearVelocity <- velocity

        this.ClearState()
    // this.MoveAndSlide() |> ignore // CharacterBody3D 用的

    override this._IntegrateForces(state) =
        let minDot = this.GetMinDot()

        for i in 0 .. state.GetContactCount() - 1 do
            let normal = state.GetContactLocalNormal(i)
            let upDot = upAxis.Dot normal

            if upDot >= minDot then
                groundContactCount <- groundContactCount + 1
                contactNormal <- contactNormal + normal
            elif upDot > -0.01f then
                steepContactCount <- steepContactCount + 1
                steepNormal <- steepNormal + normal
