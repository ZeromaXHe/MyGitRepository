namespace CatlikeCodingFS.Movement6

open Godot

type GravitySourceFS() =
    inherit Node3D()

    interface IGravitySource with
        override this.GetGravity(position: Vector3) =
            ProjectSettings.GetSetting("physics/3d/default_gravity").As<float32>()
            * ProjectSettings.GetSetting("physics/3d/default_gravity_vector").As<Vector3>()

    override this._Ready() = CustomGravity.register this

    override this._ExitTree() = CustomGravity.unregister this
