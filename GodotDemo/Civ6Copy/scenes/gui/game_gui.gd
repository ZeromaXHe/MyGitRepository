class_name GameGUI
extends CanvasLayer


signal turn_button_clicked(end_turn: bool)

# 右上角回合数和年数显示
@onready var turn_and_year_label: Label = $VBoxContainer/TopPanel/TopRightHBox/TurnAndYearLabel
# 右上角时间的显示
@onready var time_label: Label = $VBoxContainer/TopPanel/TopRightHBox/TimeLabel
# 百科面板
@onready var wiki_panel: WikiPanel = $WikiPanelContainer
# 鼠标悬停在地块上时显示的面板
@onready var mouse_hover_tile_panel: MouseHoverTilePanel = $MouseHoverTilePanel
# 右下角信息栏
@onready var info_panel: PanelContainer = $VBoxContainer/DownMargin/RightDownHBox/InfoPanel
@onready var name_label: Label = $VBoxContainer/DownMargin/RightDownHBox/InfoPanel/InfoVBox/DetailHBox/DetailVBox/NameLabel
@onready var move_label: Label = $VBoxContainer/DownMargin/RightDownHBox/InfoPanel/InfoVBox/DetailHBox/DetailVBox/MoveLabel
# 右下角回合相关
@onready var turn_label: Label = $VBoxContainer/DownMargin/RightDownHBox/TurnPanel/TurnVBox/TurnLabel
@onready var turn_button: Button = $VBoxContainer/DownMargin/RightDownHBox/TurnPanel/TurnVBox/HBoxContainer/TurnButton
# 菜单界面相关
@onready var menu_overlay: PanelContainer = $MenuOverlay


func _ready() -> void:
	wiki_panel.visible = false
	menu_overlay.visible = false
	hide_unit_info()
	# 鼠标悬停面板初始不显示
	hide_mouse_hover_tile_info()


func _process(delta: float) -> void:
	update_time_label()


func update_time_label():
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var hour_val: int = time_dict["hour"]
	time_label.text = "%2d:%2d %s" % [hour_val if hour_val <= 12 else (hour_val - 12), \
			time_dict["minute"], " AM" if hour_val <= 12 else " PM"]


func update_turn_and_year_label(turn: int, year: int) -> void:
	var year_str: String = str(year) if year >= 0 else ("前" + str(-year))
	turn_and_year_label.text = "回合 %d/500\n公元%s年" % [turn, year_str]


func show_unit_info(unit: Unit) -> void:
	info_panel.visible = true
	# TODO: 角色类型名字
	match unit.type:
		Unit.Type.SETTLER:
			name_label.text = "开拓者"
		Unit.Type.WARRIOR:
			name_label.text = "勇士"
	move_label.text = "%d/2 移动" % unit.move_capability


func hide_unit_info() -> void:
	info_panel.visible = false


func show_turn_unit_need_move() -> void:
	turn_label.text = "单位需要命令"
	turn_button.icon = load("res://assets/icon_park/注意_attention.svg")


func show_turn_end_turn() -> void:
	turn_label.text = "结束回合"
	turn_button.icon = load("res://assets/icon_park/下一步_next.svg")


func is_mouse_hover_info_shown() -> bool:
	return mouse_hover_tile_panel.visible


func show_mouse_hover_tile_info(map_coord: Vector2i, tile_info: Map.TileInfo) -> void:
	mouse_hover_tile_panel.show_info(map_coord, tile_info)


func hide_mouse_hover_tile_info() -> void:
	mouse_hover_tile_panel.hide_info()


## 点击右上角文明百科按钮
func _on_civ_pedia_button_pressed() -> void:
	wiki_panel.visible = true


## 点击右上角菜单按钮
func _on_menu_button_pressed() -> void:
	menu_overlay.visible = true


## 点击菜单中的“返回游戏”
func _on_return_button_pressed() -> void:
	menu_overlay.visible = false


## 点击菜单中的“返回主菜单”
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


## 点击菜单中的“返回桌面”
func _on_desktop_button_pressed() -> void:
	get_tree().quit()


## 点击右下角的回合按钮
func _on_turn_button_pressed() -> void:
	if turn_label.text == "结束回合":
		turn_button_clicked.emit(true)
	else:
		turn_button_clicked.emit(false)
