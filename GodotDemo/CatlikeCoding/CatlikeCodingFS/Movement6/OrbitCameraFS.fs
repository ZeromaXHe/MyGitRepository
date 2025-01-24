namespace CatlikeCodingFS.Movement6

open Godot
open Godot.Collections

[<AbstractClass>]
type OrbitCameraFS() =
    inherit Camera3D()

    let mutable focusPoint = Vector3.Zero
    let mutable previousFocusPoint = Vector3.Zero
    let mutable orbitAngles = Vector3(Mathf.DegToRad -45f, 0f, 0f)
    let mutable lastManualRotationTime = 0.0

    let mutable gravityAlignment = Quaternion.Identity
    let mutable orbitRotation = Quaternion.Identity

    let constrainAngle (angle: float32) =
        if angle < 0f then angle + Mathf.Tau
        elif angle > Mathf.Tau then angle - Mathf.Tau
        else angle

    let moveTowardsAngle (a: float32) (b: float32) (delta: float32) =
        let ca = constrainAngle a
        let cb = constrainAngle b

        if Mathf.Abs(cb - ca) <= Mathf.Pi then
            Mathf.MoveToward(ca, cb, delta)
        elif ca <= cb then
            constrainAngle <| Mathf.MoveToward(ca + Mathf.Tau, cb, delta)
        else
            constrainAngle <| Mathf.MoveToward(ca, cb + Mathf.Tau, delta)

    let deltaAngle (current: float32) (target: float32) =
        let c = constrainAngle current
        let t = constrainAngle target

        if t - c <= Mathf.Pi && t - c > -Mathf.Pi then t - c
        elif t > c then t - c - Mathf.Tau
        else t - c + Mathf.Tau

    abstract Focus: PhysicsBody3D with get, set
    abstract FocusShapeCast: ShapeCast3D with get, set
    abstract Distance: float32 with get, set
    abstract FocusRadius: float32 with get, set
    abstract FocusCentering: float32 with get, set
    abstract RotationSpeed: float32 with get, set
    abstract MinVerticalAngle: float32 with get, set
    abstract MaxVerticalAngle: float32 with get, set
    abstract AlignDelay: float with get, set
    abstract AlignSmoothRange: float32 with get, set
    abstract UpAlignmentSpeed: float32 with get, set

    member this.CameraHalfExtends =
        let y = this.Near * Mathf.Tan(0.5f * Mathf.DegToRad this.Fov)
        let x = y * 1152f / 648f // TODO: 目前直接写死，好像没找到怎么获取摄像头宽高
        GD.Print $"x: {x}, y: {y}, v:{this.VOffset}, h:{this.HOffset}"
        Vector3(x, y, 0f)

    member this.ManualRotation delta =
        let input = Input.GetVector("CameraLeft", "CameraRight", "CameraUp", "CameraDown")
        let e = 0.001f

        if Mathf.Abs input.X > e || Mathf.Abs input.Y > e then
            orbitAngles <-
                orbitAngles
                + Mathf.DegToRad this.RotationSpeed * delta * Vector3(input.Y, input.X, 0f)

            lastManualRotationTime <- Time.GetUnixTimeFromSystem()
            true
        else
            false

    member this.GetAngle(direction: Vector2) =
        let angle = Mathf.Acos -direction.Y // 这里取负，不然前后方向相反
        if direction.X < 0f then angle - Mathf.Tau else -angle // 这里也取负，不然左右方向反了

    member this.AutomaticRotation delta =
        if Time.GetUnixTimeFromSystem() - lastManualRotationTime < this.AlignDelay then
            false
        else
            let alignedDelta = gravityAlignment.Inverse() * (focusPoint - previousFocusPoint)
            let movement = Vector2(alignedDelta.X, alignedDelta.Z)
            let movementDeltaSqr = movement.LengthSquared()

            if movementDeltaSqr < 0.0001f then
                false
            else
                let headingAngle = this.GetAngle(movement / Mathf.Sqrt movementDeltaSqr)
                let deltaAbs = Mathf.Abs(deltaAngle orbitAngles.Y headingAngle)

                let mutable rotationChange =
                    Mathf.DegToRad this.RotationSpeed * Mathf.Min(delta, movementDeltaSqr)

                if deltaAbs < Mathf.DegToRad this.AlignSmoothRange then
                    rotationChange <- rotationChange * deltaAbs / Mathf.DegToRad this.AlignSmoothRange
                elif Mathf.Pi - deltaAbs < Mathf.DegToRad this.AlignSmoothRange then
                    rotationChange <- rotationChange * (Mathf.Pi - deltaAbs) / Mathf.DegToRad this.AlignSmoothRange

                orbitAngles.Y <- moveTowardsAngle orbitAngles.Y headingAngle rotationChange
                true

    member this.UpdateFocusPoint delta =
        previousFocusPoint <- focusPoint
        let targetPoint = this.Focus.GlobalPosition

        if this.FocusRadius > 0f then
            let distance = targetPoint.DistanceTo focusPoint
            let mutable t = 1f

            if distance > 0.01f && this.FocusCentering > 0f then
                t <- Mathf.Pow(1f - this.FocusCentering, delta)

            if distance > this.FocusRadius then
                t <- Mathf.Min(t, this.FocusRadius / distance)

            focusPoint <- targetPoint.Lerp(focusPoint, t)
        else
            focusPoint <- targetPoint

    member this.ConstrainAngles() =
        orbitAngles.X <-
            Mathf.Clamp(orbitAngles.X, Mathf.DegToRad this.MinVerticalAngle, Mathf.DegToRad this.MaxVerticalAngle)

        orbitAngles.Y <- constrainAngle orbitAngles.Y

    member this.UpdateGravityAlignment delta =
        let fromUp = gravityAlignment * Vector3.Up
        let toUp = CustomGravity.getUpAxis focusPoint
        let dot = Mathf.Clamp(fromUp.Dot toUp, -1f, 1f)
        let angle = Mathf.RadToDeg(Mathf.Acos dot)
        let maxAngle = this.UpAlignmentSpeed * delta
        let newAlignment = (Quaternion(fromUp, toUp) * gravityAlignment).Normalized()

        if angle <= maxAngle then
            gravityAlignment <- newAlignment
        else
            gravityAlignment <- gravityAlignment.Slerp(newAlignment, maxAngle / angle) // Godot 默认就没有 Clamp

    member this.OnValidate() =
        if this.MaxVerticalAngle < this.MinVerticalAngle then
            this.MaxVerticalAngle <- this.MinVerticalAngle

    override this._Ready() =
        focusPoint <- this.Focus.GlobalPosition
        this.Quaternion <- Quaternion.FromEuler orbitAngles
        orbitRotation <- Quaternion.FromEuler orbitAngles
        this.OnValidate()

    override this._Process(delta) =
        let df = float32 delta
        this.UpdateGravityAlignment df
        this.UpdateFocusPoint df

        if this.ManualRotation df || this.AutomaticRotation df then
            this.ConstrainAngles()
            orbitRotation <- Quaternion.FromEuler orbitAngles

        let lookRotation = gravityAlignment * orbitRotation
        let lookDirection = lookRotation * Vector3.Forward
        let mutable lookPosition = focusPoint - lookDirection * this.Distance

        let spaceState = this.GetWorld3D().DirectSpaceState

        let queryRay =
            PhysicsRayQueryParameters3D.Create(
                focusPoint,
                lookPosition,
                exclude = Array<Rid>([| this.Focus.GetRid() |])
            )
        // let queryShape = new PhysicsShapeQueryParameters3D()
        // let box = new BoxShape3D()
        // let mutable boxSize = this.CameraHalfExtends
        // boxSize.Z <- focusPoint.DistanceTo lookPosition - this.Near
        // box.Size <- boxSize
        // queryShape.Shape <- box
        // queryShape.Transform <- Transform3D(Basis(lookRotation.Inverse()), focusPoint)
        // queryShape.Exclude <- Array<Rid>([| this.Focus.GetRid() |])
        let resultRay = spaceState.IntersectRay queryRay

        if resultRay <> null && resultRay.Count > 0 then
            let distance = resultRay["position"].As<Vector3>().DistanceTo focusPoint
            lookPosition <- focusPoint - lookDirection * distance
        // 注意：这里的代码有问题，因为 Godot 的 PhysicsShapeQueryParameters3D 查询结果没有 position……
        // let resultShape = spaceState.IntersectShape queryShape
        // if resultShape <> null && resultShape.Count > 0 then
        //     let distance = resultShape[0].["position"].As<Vector3>().DistanceTo focusPoint
        //     lookPosition <- focusPoint - lookDirection * (distance + this.Near)

        // ShapeCast 本身目前也是不太适合原来 Unity 那个思路，BUG 解不了，写的我有点烦了，先走 RayCast 逻辑吧……
        if this.FocusShapeCast <> null then
            // 没看懂这里在干嘛，bug 又一堆…… 调不好，不搞了……
            // let rectOffset = lookDirection * this.Near
            // let mutable rectPosition = lookPosition + rectOffset
            // let castFrom = this.Focus.Position
            // let castLine = rectPosition - castFrom
            // let castDistance = castLine.Length()
            // let castDirection = castLine / castDistance
            let box = this.FocusShapeCast.Shape :?> BoxShape3D
            let mutable boxSize = this.CameraHalfExtends
            // boxSize.Z <- castDistance
            boxSize.Z <- focusPoint.DistanceTo lookPosition - this.Near
            box.Size <- boxSize
            // this.FocusShapeCast.Quaternion <- lookRotation
            // this.FocusShapeCast.GlobalPosition <- (castFrom + rectPosition) / 2f
            // let mutable closestPoint = rectPosition
            // let mutable closestDist = castDistance
            this.FocusShapeCast.Quaternion <- lookRotation
            this.FocusShapeCast.GlobalPosition <- (focusPoint + lookPosition) / 2f
            let mutable closestPoint = lookPosition
            let mutable closestDist = lookPosition.DistanceTo(focusPoint)

            for i in 0 .. this.FocusShapeCast.GetCollisionCount() - 1 do
                let p = this.FocusShapeCast.GetCollisionPoint(i)

                if p.DistanceTo(focusPoint) < closestPoint.DistanceTo(focusPoint) then
                    closestPoint <- p
                    closestDist <- p.DistanceTo(focusPoint)
            // rectPosition <- castFrom + castDirection * closestDist
            // lookPosition <- rectPosition - rectOffset
            lookPosition <- focusPoint - lookDirection * (closestDist + this.Near)

        this.GlobalPosition <- lookPosition
        this.Quaternion <- lookRotation
