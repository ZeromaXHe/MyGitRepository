namespace CatlikeCodingFS.GodotOfficialDemo._3D.TruckTown

open Godot

type Mood =
    | SUNRISE = 0
    | DAY = 1
    | SUNSET = 2
    | NIGHT = 3
    | MAX = 4

type TownSceneFS() =
    inherit Node3D()

    let mutable mood = Mood.DAY

    member this.Mood
        with get () = mood
        and set v = this.SetMood v

    member this.SetMood pMood =
        mood <- pMood

        match pMood with
        | Mood.SUNRISE ->
            let light = this.GetNode<DirectionalLight3D> "DirectionalLight3D"
            light.RotationDegrees <- Vector3(-20f, -150f, -137f)
            light.LightColor <- Color(0.414f, 0.377f, 0.25f)
            light.LightEnergy <- 4f
            let env = this.GetNode<WorldEnvironment> "WorldEnvironment"
            env.Environment.FogLightColor <- Color(0.686f, 0.6f, 0.467f)

            env.Environment.Sky.SkyMaterial <-
                GD.Load<ProceduralSkyMaterial> "res://Materials/GodotOfficialDemo/3D/TruckTown/Town/SkyMorning.tres"

            (this.GetNode<Node3D> "ArtificialLights").Visible <- false
        | Mood.DAY ->
            let light = this.GetNode<DirectionalLight3D> "DirectionalLight3D"
            light.RotationDegrees <- Vector3(-55f, -120f, -31f)
            light.LightColor <- Colors.White
            light.LightEnergy <- 1.45f
            let env = this.GetNode<WorldEnvironment> "WorldEnvironment"

            env.Environment.Sky.SkyMaterial <-
                GD.Load<ProceduralSkyMaterial> "res://Materials/GodotOfficialDemo/3D/TruckTown/Town/SkyDay.tres"

            env.Environment.FogLightColor <- Color(0.62f, 0.601f, 0.601f)
            (this.GetNode<Node3D> "ArtificialLights").Visible <- false
        | Mood.SUNSET ->
            let light = this.GetNode<DirectionalLight3D> "DirectionalLight3D"
            light.RotationDegrees <- Vector3(-19f, -31f, 62f)
            light.LightColor <- Color(0.488f, 0.3f, 0.1f)
            light.LightEnergy <- 4f
            let env = this.GetNode<WorldEnvironment> "WorldEnvironment"

            env.Environment.Sky.SkyMaterial <-
                GD.Load<ProceduralSkyMaterial> "res://Materials/GodotOfficialDemo/3D/TruckTown/Town/SkySunset.tres"

            env.Environment.FogLightColor <- Color(0.776f, 0.549f, 0.502f)
            (this.GetNode<Node3D> "ArtificialLights").Visible <- true
        | Mood.NIGHT ->
            let light = this.GetNode<DirectionalLight3D> "DirectionalLight3D"
            light.RotationDegrees <- Vector3(-49f, 116f, -46f)
            light.LightColor <- Color(0.232f, 0.415f, 0.413f)
            light.LightEnergy <- 0.7f
            let env = this.GetNode<WorldEnvironment> "WorldEnvironment"

            env.Environment.Sky.SkyMaterial <-
                GD.Load<ProceduralSkyMaterial> "res://Materials/GodotOfficialDemo/3D/TruckTown/Town/SkyNight.tres"

            env.Environment.FogLightColor <- Color(0.2f, 0.149f, 0.125f)
            (this.GetNode<Node3D> "ArtificialLights").Visible <- true
        | _ -> ()

    override this._Input(event) =
        if event.IsActionPressed "cycle_mood" then
            this.Mood <- enum<Mood> <| Mathf.Wrap(int mood + 1, 0, int Mood.MAX)
