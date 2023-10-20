# 官方文档常用记录

## 代码顺序

[官方文档地址《GDScript style guide: Code Order》](https://docs.godotengine.org/en/4.1/tutorials/scripting/gdscript/gdscript_styleguide.html#code-order)

```gdscript
01. @tool
02. class_name
03. extends
04. # docstring

05. signals
06. enums
07. constants
08. @export variables
09. public variables
10. private variables
11. @onready variables

12. optional built-in virtual _init method
13. optional built-in virtual _enter_tree() method
14. built-in virtual _ready method
15. remaining built-in virtual methods
16. public methods
17. private methods
18. subclasses
```

## 文件路径

[官方文档地址《File and data I/O：File paths in Godot projects》](https://docs.godotengine.org/en/4.1/tutorials/io/data_paths.html#file-paths-in-godot-projects)



To store persistent data files, like the player's save or settings, you want to use `user://` instead of `res://` as your path's prefix. This is because when the game is running, the project's file system will likely be read-only.

The `user://` prefix points to a different directory on the user's device. Unlike `res://`, the directory pointed at by `user://` is created automatically and *guaranteed* to be writable to, even in an exported project.

The location of the `user://` folder depends on what is configured in the Project Settings:

- By default, the `user://` folder is created within Godot's [editor data path](https://docs.godotengine.org/en/4.1/tutorials/io/data_paths.html#doc-data-paths-editor-data-paths) in the `app_userdata/[project_name]` folder. This is the default so that prototypes and test projects stay self-contained within Godot's data folder.
- If [application/config/use_custom_user_dir](https://docs.godotengine.org/en/4.1/classes/class_projectsettings.html#class-projectsettings-property-application-config-use-custom-user-dir) is enabled in the Project Settings, the `user://` folder is created **next to** Godot's editor data path, i.e. in the standard location for applications data.
  - By default, the folder name will be inferred from the project name, but it can be further customized with [application/config/custom_user_dir_name](https://docs.godotengine.org/en/4.1/classes/class_projectsettings.html#class-projectsettings-property-application-config-custom-user-dir-name). This path can contain path separators, so you can use it e.g. to group projects of a given studio with a `Studio Name/Game Name` structure.

On desktop platforms, the actual directory paths for `user://` are:

| Type                | Location                                                     |
| ------------------- | ------------------------------------------------------------ |
| Default             | Windows: `%APPDATA%\Godot\app_userdata\[project_name]`<br/>macOS: `~/Library/Application Support/Godot/app_userdata/[project_name]`<br/>Linux: `~/.local/share/godot/app_userdata/[project_name]` |
| Custom dir          | Windows: `%APPDATA%\[project_name]`<br/>macOS: `~/Library/Application Support/[project_name]`<br/>Linux: `~/.local/share/[project_name]` |
| Custom dir and name | Windows: `%APPDATA%\[custom_user_dir_name]`<br/>macOS: `~/Library/Application Support/[custom_user_dir_name]`<br/>Linux: `~/.local/share/[custom_user_dir_name]` |

`[project_name]` is based on the application name defined in the Project Settings, but you can override it on a per-platform basis using [feature tags](https://docs.godotengine.org/en/4.1/tutorials/export/feature_tags.html#doc-feature-tags).

On mobile platforms, this path is unique to the project and is not accessible by other applications for security reasons.

On HTML5 exports, `user://` will refer to a virtual filesystem stored on the device via IndexedDB. (Interaction with the main filesystem can still be performed through the [JavaScriptBridge](https://docs.godotengine.org/en/4.1/classes/class_javascriptbridge.html#class-javascriptbridge) singleton.)

# 常用模板代码

## Tween

代码示例（来自 GodotDemo/GodotProjects/scenes/gui/gui.gd）：
```gdscript
# Godot 4 的 Tween 不再是节点了，直接这样调用即可获取。具体看 Tween 的文档
# 貌似不能复用，提取到 _ready() 里面初始化会无效
var tween = get_tree().create_tween()
tween.tween_property(hp_bar, "value", new_health, 0.3)
var bar_fill_style: StyleBoxFlat = hp_bar.get("theme_override_styles/fill")
var original_color: Color = Color("#b44141")
var highlight_color: Color = Color.LIGHT_CORAL
tween.tween_property(bar_fill_style, "bg_color", highlight_color, 0.15)
tween.tween_property(bar_fill_style, "bg_color", original_color, 0.15)
```
