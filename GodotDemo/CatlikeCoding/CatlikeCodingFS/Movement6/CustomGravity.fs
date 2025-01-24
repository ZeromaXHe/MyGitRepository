namespace CatlikeCodingFS.Movement6

open System.Collections.Generic
open Godot

type IGravitySource =
    abstract GetGravity: Vector3 -> Vector3

module CustomGravity =
    let mutable private defaultGravity = 0f

    let private initGravity () =
        if defaultGravity = 0f then
            defaultGravity <- ProjectSettings.GetSetting("physics/3d/default_gravity").As<float32>()

    let sources = List<IGravitySource>()

    let register (source: IGravitySource) =
        if sources.Contains source then
            GD.PushError "重复注册重力源！"

        sources.Add source

    let unregister (source: IGravitySource) =
        if not <| sources.Contains source then
            GD.PushError "注销不存在的重力源！"

        sources.Remove source |> ignore

    let getGravity (position: Vector3) =
        let mutable g = Vector3.Zero

        for i in 0 .. sources.Count - 1 do
            g <- g + sources[i].GetGravity position

        g

    let getUpAxis (position: Vector3) =
        let mutable g = Vector3.Zero

        for i in 0 .. sources.Count - 1 do
            g <- g + sources[i].GetGravity position

        -(g.Normalized())

    let getGravityAndUpAxis (position: Vector3) =
        let gravity = getGravity position
        let upAxis = -(gravity.Normalized())
        gravity, upAxis
