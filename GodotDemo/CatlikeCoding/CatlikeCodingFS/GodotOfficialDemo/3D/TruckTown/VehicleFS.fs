namespace CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown

open Godot

[<AbstractClass>]
type VehicleFS() =
    inherit VehicleBody3D()

    let STEER_SPEED = 1.5f
    let STEER_LIMIT = 0.4f
    let BRAKE_STRENGTH = 2.0f

    let mutable previousSpeed = 0f
    let mutable steerTarget = 0f

    let mutable desiredEnginePitch = 0f
    let mutable engineSound: AudioStreamPlayer3D = null
    let mutable impactSound: AudioStreamPlayer3D = null

    abstract EngineForceValue: float32 with get, set

    override this._Ready() =
        previousSpeed <- this.LinearVelocity.Length()
        engineSound <- this.GetNode<AudioStreamPlayer3D> "EngineSound"
        impactSound <- this.GetNode<AudioStreamPlayer3D> "ImpactSound"
        desiredEnginePitch <- engineSound.PitchScale

    override this._PhysicsProcess delta =
        steerTarget <- Input.GetAxis("MoveRight", "MoveLeft")
        steerTarget <- steerTarget * STEER_LIMIT
        // 引擎声音模拟（不真实，因为该车脚本没有换挡或引擎 RPM 的概念）
        desiredEnginePitch <- 0.05f + this.LinearVelocity.Length() / (this.EngineForceValue * 0.5f)
        // 光滑地改变音高，避免在碰撞时突然改变
        engineSound.PitchScale <- Mathf.Lerp(engineSound.PitchScale, desiredEnginePitch, 0.2f)

        if Mathf.Abs(this.LinearVelocity.Length() - previousSpeed) > 1f then
            // 突然速度变化，很可能是因为碰撞。播放一个碰撞声音来给予音效反馈，并振动以给予触觉反馈
            impactSound.Play()
            Input.VibrateHandheld 100

            for joypad in Input.GetConnectedJoypads() do
                Input.StartJoyVibration(joypad, 0f, 0.5f, 0.1f)
        // 当使用触控时，自动加速（倒退会覆盖加速）
        if DisplayServer.IsTouchscreenAvailable() || Input.IsActionPressed "MoveUp" then
            // 在低速时提高发动机力，来使得初始加速度更快
            let speed = this.LinearVelocity.Length()

            if speed < 5f && not <| Mathf.IsZeroApprox speed then
                this.EngineForce <- Mathf.Clamp(this.EngineForceValue * 5f / speed, 0f, 100f)
            else
                this.EngineForce <- this.EngineForceValue

            if not <| DisplayServer.IsTouchscreenAvailable() then
                // 如果未完全按住扳机，则应用模拟油门系数以获得更精细的加速
                this.EngineForce <- this.EngineForce * Input.GetActionStrength "MoveUp"
        else
            this.EngineForce <- 0f

        if Input.IsActionPressed "MoveDown" then
            // 在低速时增加发动机力，使初始倒车更快。
            let speed = this.LinearVelocity.Length()

            if speed < 5f && not <| Mathf.IsZeroApprox speed then
                this.EngineForce <- - Mathf.Clamp(this.EngineForceValue * BRAKE_STRENGTH * 5f / speed, 0f, 100f)
            else
                this.EngineForce <- -this.EngineForceValue * BRAKE_STRENGTH
            // 如果未完全按住扳机，则应用模拟制动系数以获得更精细的制动。
            this.EngineForce <- this.EngineForce * Input.GetActionStrength "MoveDown"

        this.Steering <- Mathf.MoveToward(this.Steering, steerTarget, STEER_SPEED * float32 delta)
        previousSpeed <- this.LinearVelocity.Length()
