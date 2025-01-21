namespace CatlikeCodingFS.Movement6

open Godot

module CustomGravity =
    let mutable private defaultGravity = 0f

    let private initGravity () =
        if defaultGravity = 0f then
            defaultGravity <- ProjectSettings.GetSetting("physics/3d/default_gravity").As<float32>()

    let getGravity (position: Vector3) =
        initGravity ()
        position.Normalized() * -defaultGravity

    let getUpAxis (position: Vector3) =
        initGravity ()
        let up = position.Normalized()
        if defaultGravity > 0f then up else -up

    let getGravityAndUpAxis (position: Vector3) =
        let gravity = getGravity position
        let upAxis = getUpAxis position
        gravity, upAxis
