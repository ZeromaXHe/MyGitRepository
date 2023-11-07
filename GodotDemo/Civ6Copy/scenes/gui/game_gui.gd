class_name GameGUI
extends CanvasLayer


signal turn_button_clicked(end_turn: bool)
signal city_button_pressed
signal city_product_settler_button_pressed

# 右上角回合数和年数显示
@onready var turn_and_year_label: Label = $VBoxContainer/TopPanel/TopRightHBox/TurnAndYearLabel
# 右上角时间的显示
@onready var time_label: Label = $VBoxContainer/TopPanel/TopRightHBox/TimeLabel
# 百科面板
@onready var wiki_panel: WikiPanel = $WikiPanelContainer
# 鼠标悬停在地块上时显示的面板
@onready var mouse_hover_tile_panel: MouseHoverTilePanel = $MouseHoverTilePanel
# 右下角单位信息栏
@onready var unit_info_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel
@onready var unit_texture_rect: TextureRect = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel/UnitInfoVBox/DetailHBox/UnitTextureRect
@onready var unit_city_button: Button = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel/UnitInfoVBox/ButtonHBox/CityButton
@onready var unit_name_label: Label = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel/UnitInfoVBox/DetailHBox/DetailVBox/NameLabel
@onready var unit_move_label: Label = $VBoxContainer/MainMargin/RightDownHBox/UnitInfoPanel/UnitInfoVBox/DetailHBox/DetailVBox/MoveLabel

# 右下角城市信息栏
@onready var city_info_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel
# 产出选择按钮
@onready var culture_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/CultureCheckBox
@onready var food_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/FoodCheckBox
@onready var product_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/ProductCheckBox
@onready var science_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/ScienceCheckBox
@onready var religion_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/ReligionCheckBox
@onready var gold_check_box: CheckBox = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/YieldHBox/GoldCheckBox
# 城市名字相关
@onready var city_name_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/NamePanel
@onready var capital_texture_rect: TextureRect = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/NamePanel/NameHBox/CapitalTextureRect
@onready var city_name_label: Label = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/NamePanel/NameHBox/NameLabel
# 城市所属文明图片
@onready var city_pic_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/CityPicPanel
@onready var city_texture_rect: TextureRect = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/CityPicPanel/CityTextureRect
# 城市生产相关
@onready var city_production_button: Button = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/ButtonHBox/ProductButton
@onready var city_product_texture_rect: TextureRect = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/ProductTextureRect
@onready var city_producing_label: Label = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/RightVBox/ProducingLabel
@onready var city_data_label: Label = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/RightVBox/DataLabel
@onready var city_intro_label: Label = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/DetailHBox/RightVBox/IntroLabel
@onready var city_product_progress: ProgressBar = $VBoxContainer/MainMargin/RightDownHBox/CityInfoPanel/CityInfoVBox/ProgressHBox/ProductBar

# 右下角回合相关
@onready var turn_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/TurnPanel
@onready var turn_label: Label = $VBoxContainer/MainMargin/RightDownHBox/TurnPanel/TurnVBox/TurnLabel
@onready var turn_button: Button = $VBoxContainer/MainMargin/RightDownHBox/TurnPanel/TurnVBox/HBoxContainer/TurnButton
# 右边城市生产选择界面
@onready var city_product_panel: PanelContainer = $VBoxContainer/MainMargin/RightDownHBox/CityProductPanel
# 菜单界面相关
@onready var menu_overlay: PanelContainer = $MenuOverlay


func _ready() -> void:
	wiki_panel.hide()
	menu_overlay.hide()
	# 右下角面板初始化
	turn_panel.show()
	hide_unit_info()
	hide_city_info()
	city_product_panel.hide()
	# 鼠标悬停面板初始不显示
	hide_mouse_hover_tile_info()


func _process(delta: float) -> void:
	update_time_label()


func update_time_label():
	var time_dict: Dictionary = Time.get_time_dict_from_system()
	var hour_val: int = time_dict["hour"]
	time_label.text = "%02d:%02d %s" % [hour_val if hour_val <= 12 else (hour_val - 12), \
			time_dict["minute"], " AM" if hour_val <= 12 else " PM"]


func update_turn_and_year_label(turn: int, year: int) -> void:
	var year_str: String = str(year) if year >= 0 else ("前" + str(-year))
	turn_and_year_label.text = "回合 %d/500\n公元%s年" % [turn, year_str]


func show_city_info(city: City) -> void:
	hide_unit_info()
	city_name_label.text = city.city_name
	capital_texture_rect.visible = city.capital
	# 城市所属玩家颜色
	city_texture_rect.modulate = city.player.second_color
	city_name_label.add_theme_color_override("font_color", city.player.second_color)
	city_name_panel.get("theme_override_styles/panel").set("bg_color", city.player.main_color)
	city_pic_panel.get("theme_override_styles/panel").set("bg_color", city.player.main_color)
	# 产量显示
	culture_check_box.text = yield_text(city.yield_culture)
	food_check_box.text = yield_text(city.yield_food)
	product_check_box.text = yield_text(city.yield_product)
	science_check_box.text = yield_text(city.yield_science)
	religion_check_box.text = yield_text(city.yield_religion)
	gold_check_box.text = yield_text(city.yield_gold)
	# 生产单位显示
	if city.producing_unit_type == -1:
		city_product_texture_rect.texture = null
		city_producing_label.text = "没有生产任何东西"
		city_data_label.text = ""
		city_intro_label.text = ""
		city_product_progress.value = 0
	else:
		city_product_texture_rect.texture = Unit.get_unit_pic_webp_256x256(city.producing_unit_type)
		city_producing_label.text = Unit.get_unit_name(city.producing_unit_type)
		# TODO: 单位数据
		city_data_label.text = "移动力：2"
		city_intro_label.text = "这是正在制造一个" + city_producing_label.text + "的简介"
		# TODO: 先全部按开拓者的生产计算
		city_product_progress.value = city.production_val * 100.0 / 80.0
	
	city_info_panel.show()


func yield_text(val: float) -> String:
	if val < 0:
		return "%.1f" % val
	if val == 0:
		return "0"
	else:
		return "+%.1f" % val

func hide_city_info() -> void:
	city_info_panel.hide()
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


func show_unit_info(unit: Unit) -> void:
	hide_city_info()
	
	unit_name_label.text = Unit.get_unit_name(unit.type)
	match unit.type:
		Unit.Type.SETTLER:
			unit_city_button.show()
			unit_texture_rect.texture = load("res://assets/civ6_origin/unit/png_200/unit_settler.png")
		Unit.Type.WARRIOR:
			unit_city_button.hide()
			unit_texture_rect.texture = load("res://assets/civ6_origin/unit/png_200/unit_warrior.png")
	unit_move_label.text = "%d/%d 移动" % [unit.move_capability, unit.get_move_range()]
	unit_info_panel.show()


func hide_unit_info() -> void:
	unit_info_panel.hide()


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


## 点击单位的建造城市按钮
func _on_city_button_pressed() -> void:
	city_button_pressed.emit()


## 点击城市的“生产”按钮
func _on_product_button_pressed() -> void:
	if city_production_button.button_pressed:
		show_city_product_panel()
	else:
		hide_city_product_panel()


## 点击城市生产面板的关闭按钮
func _on_city_product_panel_close_button_pressed() -> void:
	hide_city_product_panel()
	city_production_button.button_pressed = false


## 点击城市生产面板的生产开拓者按钮
func _on_settler_button_pressed() -> void:
	city_product_settler_button_pressed.emit()
