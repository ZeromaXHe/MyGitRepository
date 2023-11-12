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

## 富文本 BBCode

[BBCode in RichTextLabel](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html)



| Tag                                                          | Example                                                      |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| **b**<br />Makes `{text}` use the bold (or bold italics) font of `RichTextLabel`. | `[b]{text}[/b]`                                              |
| **i**<br />Makes `{text}` use the italics (or bold italics) font of `RichTextLabel`. | `[i]{text}[/i]`                                              |
| **u**<br />Makes `{text}` underlined.                        | `[u]{text}[/u]`                                              |
| **s**<br />Makes `{text}` strikethrough.                     | `[s]{text}[/s]`                                              |
| **code**<br />Makes `{text}` use the mono font of `RichTextLabel`. | `[code]{text}[/code]`                                        |
| **p**<br />Adds new paragraph with `{text}`. Supports configuration options, see [Paragraph options](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-paragraph-options). | `[p]{text}[/p]`<br />`[p {options}]{text}[/p]`               |
| **center**<br />Makes `{text}` horizontally centered.Same as `[p align=center]`. | `[center]{text}[/center]`                                    |
| **left**<br />Makes `{text}` horizontally left-aligned.Same as `[p align=left]`. | `[left]{text}[/left]`                                        |
| **right**<br />Makes `{text}` horizontally right-aligned.Same as `[p align=right]`. | `[right]{text}[/right]`                                      |
| **fill**<br />Makes `{text}` fill the full width of `RichTextLabel`.Same as `[p align=fill]`. | `[fill]{text}[/fill]`                                        |
| **indent**<br />Indents `{text}` once.                       | `[indent]{text}[/indent]`                                    |
| **url**<br />Creates a hyperlink (underlined and clickable text). Can contain optional `{text}` or display `{link}` as is.**Must be handled with the "meta_clicked" signal to have an effect,** see [Handling [url\] tag clicks](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-handling-url-tag-clicks). | `[url]{link}[/url]`<br />`[url={link}]{text}[/url]`          |
| **hint**<br />Creates a tooltip hint that is displayed when hovering the text with the mouse. Tooltip text should not be quoted (quotes will appear as-is in the tooltip otherwise). | `[hint={tooltip text displayed on hover}]{text}[/hint]`      |
| **img**<br />Inserts an image from the `{path}` (can be any valid [Texture2D](https://docs.godotengine.org/en/4.1/classes/class_texture2d.html#class-texture2d) resource).If `{width}` is provided, the image will try to fit that width maintaining the aspect ratio.If both `{width}` and `{height}` are provided, the image will be scaled to that size.If `{valign}` configuration is provided, the image will try to align to the surrounding text, see [Image vertical alignment](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-image-alignment).Supports configuration options, see [Image options](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-image-options). | `[img]{path}[/img]`<br />`[img={width}]{path}[/img]`<br />`[img={width}x{height}]{path}[/img]`<br />`[img={valign}]{path}[/img]`<br />`[img {options}]{path}[/img]` |
| **font**<br />Makes `{text}` use a font resource from the `{path}`.Supports configuration options, see [Font options](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-font-options). | `[font={path}]{text}[/font]`<br />`[font {options}]{text}[/font]` |
| **font_size**<br />Use custom font size for `{text}`.        | `[font_size={size}]{text}[/font_size]`                       |
| **dropcap**<br />Use a different font size and color for `{text}`, while making the tag's contents span multiple lines if it's large enough.A [drop cap](https://www.computerhope.com/jargon/d/dropcap.htm) is typically one uppercase character, but `[dropcap]` supports containing multiple characters. `margins` values are comma-separated and can be positive, zero or negative. Negative top and bottom margins are particularly useful to allow the rest of the paragraph to display below the dropcap. | `[dropcap font_size={size} color={color} margins={left},{top},{right},{bottom}]{text}[/dropcap]` |
| **opentype_features**<br />Enables custom OpenType font features for `{text}`. Features must be provided as a comma-separated `{list}`. | `[opentype_features={list}]`<br />`{text}`<br />`[/opentype_features]` |
| **color**<br />Changes the color of `{text}`. Color must be provided by a common name (see [Named colors](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-named-colors)) or using the HEX format (e.g. `#ff00ff`, see [Hexadecimal color codes](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-hex-colors)). | `[color={code/name}]{text}[/color]`                          |
| **bgcolor**<br />Draws the color behind `{text}`. This can be used to highlight text. Accepts same values as the `color` tag. | `[bgcolor={code/name}]{text}[/bgcolor]`                      |
| **fgcolor**<br />Draws the color in front of `{text}`. This can be used to "redact" text by using an opaque foreground color. Accepts same values as the `color` tag. | `[fgcolor={code/name}]{text}[/fgcolor]`                      |
| **outline_size**<br />Use custom font outline size for `{text}`. | `[outline_size={size}]`<br />`{text}`<br />`[/outline_size]` |
| **outline_color**<br />Use custom outline color for `{text}`. Accepts same values as the `color` tag. | `[outline_color={code/name}]`<br />`{text}`<br />`[/outline_color]` |
| **table**<br />Creates a table with the `{number}` of columns. Use the `cell` tag to define table cells. | `[table={number}]{cells}[/table]`                            |
| **cell**<br />Adds a cell with `{text}` to the table.If `{ratio}` is provided, the cell will try to expand to that value proportionally to other cells and their ratio values.Supports configuration options, see [Cell options](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-cell-options). | `[cell]{text}[/cell]`<br />`[cell={ratio}]{text}[/cell]`<br />`[cell {options}]{text}[/cell]` |
| **ul**<br />Adds an unordered list. List `{items}` must be provided by putting one item per line of text.The bullet point can be customized using the `{bullet}` parameter, see [Unordered list bullet](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-unordered-list-bullet). | `[ul]{items}[/ul]`<br />`[ul bullet={bullet}]{items}[/ul]`   |
| **ol**<br />Adds an ordered (numbered) list of the given `{type}` (see [Ordered list types](https://docs.godotengine.org/en/4.1/tutorials/ui/bbcode_in_richtextlabel.html#doc-bbcode-in-richtextlabel-list-types)). List `{items}` must be provided by putting one item per line of text. | `[ol type={type}]{items}[/ol]`                               |
| **lb**, **rb**<br />Adds `[` and `]` respectively. Allows escaping BBCode markup.These are self-closing tags, which means you do not need to close them (and there is no `[/lb]` or `[/rb]` closing tag). | `[lb]b[rb]text[lb]/b[rb]` will display as `[b]text[/b]`.     |
| Several Unicode control characters can be added using their own self-closing tags.<br />This can result in easier maintenance compared to pasting thosecontrol characters directly in the text. | `[lrm]` (left-to-right mark), `[rlm]` (right-to-left mark), `[lre]` (left-to-right embedding),`[rle]` (right-to-left embedding), `[lro]` (left-to-right override), `[rlo]` (right-to-left override),`[pdf]` (pop directional formatting), `[alm]` (Arabic letter mark), `[lri]` (left-to-right isolate),`[rli]` (right-to-left isolate), `[fsi]` (first strong isolate), `[pdi]` (pop directional isolate),`[zwj]` (zero-width joiner), `[zwnj]` (zero-width non-joiner), `[wj]` (word joiner),`[shy]` (soft hyphen) |

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
