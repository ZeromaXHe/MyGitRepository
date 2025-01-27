namespace CatlikeCodingFS.GodotOfficialDemo._3D.Navigation

open System
open Godot

[<AbstractClass>]
type RobotBaseFS() =
    inherit Marker3D()

    let mutable navPathLine = Unchecked.defaultof<Line3dFS>
    let mutable navAgent: NavigationAgent3D = null

    abstract CharacterSpeed: float32 with get, set
    abstract ShowPath: bool with get, set

    abstract Line3dInitiator: Func<Line3dFS>

    member this.SetTargetPosition targetPosition =
        navAgent.SetTargetPosition targetPosition
        // 使用 NavigationServer API 获取完整的导航路径。
        if this.ShowPath then
            let startPosition = this.GlobalTransform.Origin
            let optimize = true
            let navigationMap = this.GetWorld3D().GetNavigationMap()

            let path =
                NavigationServer3D.MapGetPath(navigationMap, startPosition, targetPosition, optimize)

            navPathLine.DrawPath path

    override this._Ready() =
        navAgent <- this.GetNode<NavigationAgent3D> "NavigationAgent3D"
        navPathLine <- this.Line3dInitiator.Invoke()
        this.AddChild navPathLine
        navPathLine.SetAsTopLevel true

    override this._PhysicsProcess(delta) =
        if not <| navAgent.IsNavigationFinished() then
            let nextPosition = navAgent.GetNextPathPosition()
            let mutable offset = nextPosition - this.GlobalPosition
            this.GlobalPosition <- this.GlobalPosition.MoveToward(nextPosition, float32 delta * this.CharacterSpeed)
            // 让机器人看我们行进的方向。
            // 将Y夹紧为0，这样机器人只看左右，而不是上下。
            offset.Y <- 0f

            if not <| offset.IsZeroApprox() then
                this.LookAt(this.GlobalPosition + offset, Vector3.Up)
