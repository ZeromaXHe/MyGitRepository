namespace CatlikeCodingFS.Basics1

open Godot

module FunctionLibrary =
    let sin (x: float32) = Mathf.Sin x
    let cos (x: float32) = Mathf.Cos x
    let abs (x: float32) = Mathf.Abs x
    let sqrt (x: float32) = Mathf.Sqrt x
    let PI = Mathf.Pi

    let wave u v t =
        let mutable p = Vector3.Zero
        p.X <- u
        p.Y <- sin <| PI * (u + v + t)
        p.Z <- v
        p

    let multiWave u v t =
        let mutable p = Vector3.Zero
        p.X <- u
        p.Y <- sin <| PI * (u + 0.5f * t)
        p.Y <- p.Y + 0.5f * sin (2f * PI * (v + t))
        p.Y <- p.Y + sin (PI * (u + v + 0.25f * t))
        p.Y <- p.Y * (1f / 2.5f)
        p.Z <- v
        p

    let ripple u v t =
        let d = sqrt <| u * u + v * v
        let mutable p = Vector3.Zero
        p.X <- u
        p.Y <- sin <| PI * (4f * d - t)
        p.Y <- p.Y / (1f + 10f * d)
        p.Z <- v
        p

    let sphere u v t =
        let r = 0.9f + 0.1f * sin (PI * (6f * u + 4f * v + t))
        let s = r * cos (0.5f * PI * v)
        let mutable p = Vector3.Zero
        p.X <- s * sin (PI * u)
        p.Y <- r * sin (PI * 0.5f * v)
        p.Z <- s * cos (PI * u)
        p

    let torus u v t =
        let r1 = 0.7f + 0.1f * sin (PI * (6f * u + 0.5f * t))
        let r2 = 0.15f + 0.05f * sin (PI * (8f * u + 4f * v + 2f * t))
        let s = r1 + r2 * cos (PI * v)
        let mutable p = Vector3.Zero
        p.X <- s * sin (PI * u)
        p.Y <- r2 * sin (PI * v)
        p.Z <- s * cos (PI * u)
        p

    type Function = float32 -> float32 -> float32 -> Vector3

    type FunctionName =
        | Wave = 0
        | MultiWave = 1
        | Ripple = 2
        | Sphere = 3
        | Torus = 4

    let private functions: Function array = [| wave; multiWave; ripple; sphere; torus |]
    let getFunction (name: FunctionName) = functions[int name]
