class_name GameGUI
extends CanvasLayer


signal city_product_settler_button_pressed


# 顶部面板
@onready var top_panel: GameTopPanel = $VBoxContainer/TopPanel
# 百科面板
@onready var wiki_panel: WikiPanel = $WikiPanelContainer
# 鼠标悬停在地块上时显示的面板
@onready var mouse_hover_tile_panel: MouseHoverTilePanel = $MouseHoverTilePanel
# 右下角单位信息栏
@onready var unit_info_panel: GameUnitInfoPanel = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel
# 右下角城市信息栏
@onready var city_info_panel: GameCityInfoPanel = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel
# 右下角回合相关
@onready var turn_panel: GameTurnPanel = $VBoxContainer/MainMargin/RightDownHBox/TurnPanel
# 右边城市生产选择界面
@onready var city_product_panel: GameCityProductPanel = $VBoxContainer/MainMargin/RightDownHBox/CityProductPanel
# 菜单界面相关
@onready var menu_overlay: PanelContainer = $MenuOverlay


func _ready() -> void:
	wiki_panel.hide()
	menu_overlay.hide()
	# 右下角面板初始化
	hide_unit_info()
	hide_city_info()
	hide_city_product_panel()
	# 鼠标悬停面板初始不显示
	hide_mouse_hover_tile_info()


func signal_binding_with_game(game: HotSeatGame) -> void:
	game.turn_changed.connect(top_panel.handle_turn_changed)
	game.chosen_unit_changed.connect(unit_info_panel.handle_chosen_unit_changed)
	game.chosen_city_changed.connect(city_info_panel.handle_chosen_city_changed)
	game.turn_status_changed.connect(turn_panel.handle_turn_status_changed)
	# 处理回合按钮信号
	turn_panel.turn_button_clicked.connect(game.handle_turn_button_clicked)
	# 处理建立城市按钮的信号
	unit_info_panel.city_button_pressed.connect(game.handle_city_button_pressed)
	# 处理城市信息界面生产按钮的按下状态修改的信号
	city_info_panel.production_button_toggled.connect(handle_city_info_production_button_toggled)
	# 处理城市生产界面的信号
	city_product_panel.settler_button_pressed.connect(game.handle_city_product_settler_button_pressed)
	city_product_panel.close_button_pressed.connect(handle_city_product_panel_close_button_pressed)


func show_city_info() -> void:
	hide_unit_info()
	city_info_panel.show_info()

func hide_city_info() -> void:
	city_info_panel.hide_info()
	hide_city_product_panel()


func show_city_product_panel() -> void:
	city_product_panel.show()
	hide_turn_panel()


func hide_city_product_panel() -> void:
	city_product_panel.hide()
	show_turn_panel()


func show_turn_panel() -> void:
	turn_panel.show()


func hide_turn_panel() -> void:
	turn_panel.hide()


func show_unit_info() -> void:
	hide_city_info()
	unit_info_panel.show_info()


func hide_unit_info() -> void:
	unit_info_panel.hide_info()


func is_mouse_hover_info_shown() -> bool:
	return mouse_hover_tile_panel.visible


func show_mouse_hover_tile_info(map_coord: Vector2i, tile_info: Map.TileInfo) -> void:
	mouse_hover_tile_panel.show_info(map_coord, tile_info)


func hide_mouse_hover_tile_info() -> void:
	mouse_hover_tile_panel.hide_info()


func handle_city_info_production_button_toggled(button_pressed: bool) -> void:
	if button_pressed:
		show_city_product_panel()
	else:
		hide_city_product_panel()


## 点击城市生产面板的关闭按钮
func handle_city_product_panel_close_button_pressed() -> void:
	hide_city_product_panel()
	city_info_panel.set_product_button_pressed(false)


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
