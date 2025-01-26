namespace CatlikeCodingFS.GodotOfficialDemo._3D.VoxelGame

open Godot
open Godot.Collections

[<AbstractClass>]
type SettingsFS() =
    inherit Node()

    static let mutable instance = Unchecked.defaultof<SettingsFS>
    static member Instance = instance

    member val RenderDistance = 7 with get, set
    member val FogEnabled = true with get, set
    member val FogDistance = 32f with get, set // 不保存，仅仅在运行时使用
    member val WorldType = 0 with get, set // 不保存，仅仅在运行时使用

    member val SavePath = "user://settings.json" with get, set

    member this.SaveSettings() =
        let file = FileAccess.Open(this.SavePath, FileAccess.ModeFlags.Write)
        let data = new Dictionary()
        data["render_distance"] <- this.RenderDistance
        data["fog_enabled"] <- this.FogDistance
        file.StoreLine <| Json.Stringify data

    override this._Ready() = instance <- this

    override this._EnterTree() =
        if FileAccess.FileExists this.SavePath then
            let file = FileAccess.Open(this.SavePath, FileAccess.ModeFlags.Read)

            while file.GetPosition() < file.GetLength() do
                // 从存档文件下一行获取保存的字典
                let json = new Json()
                json.Parse <| file.GetLine() |> ignore
                let data = json.GetData().AsGodotDictionary()
                this.RenderDistance <- data["render_distance"].AsInt32()
                this.FogEnabled <- data["fog_enabled"].AsBool()
        else
            this.SaveSettings()
