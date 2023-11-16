class_name City
extends Node2D


signal city_clicked(city: City)
signal producing_unit_type_changed(type: UnitTypeTable.Type)
signal production_val_changed(val: float)
# 单位产量变化
signal yield_culture_changed(val: float)
signal yield_food_changed(val: float)
signal yield_product_changed(val: float)
signal yield_science_changed(val: float)
signal yield_religion_changed(val: float)
signal yield_gold_changed(val: float)
# 新单位建成
signal product_completed(unit_type: UnitTypeTable.Type, city: City)

var id: int

# 回合产量相关
var yield_culture: float = 0.0:
	set(val):
		yield_culture = val
		yield_culture_changed.emit(val)
var yield_food: float = 0.0:
	set(val):
		yield_food = val
		yield_food_changed.emit(val)
var yield_product: float = 1.0:
	set(val):
		yield_product = val
		yield_product_changed.emit(val)
var yield_science: float = 0.0:
	set(val):
		yield_science = val
		yield_science_changed.emit(val)
var yield_religion: float = 0.0:
	set(val):
		yield_religion = val
		yield_religion_changed.emit(val)
var yield_gold: float = 0.0:
	set(val):
		yield_gold = val
		yield_gold_changed.emit(val)
# 生产相关
var production_val: float = 0.0:
	set(val):
		production_val = val
		production_val_changed.emit(val)
		# TODO: 暂时只用开拓者成本的计算
		product_progress_bar.value = production_val * 100.0 / 80.0
		if producing_unit_type == -1:
			product_turn_label.text = "-"
		else:
			product_turn_label.text = str(ceili((80.0 - production_val) / yield_product))
var producing_unit_type: UnitTypeTable.Type = -1:
	set(type):
		producing_unit_type = type
		producing_unit_type_changed.emit(type)
		if type == -1:
			product_texture_rect.texture = null
			product_turn_label.text = "-"
		else:
			product_texture_rect.texture = Unit.get_unit_pic_webp_64x64(type)
			product_turn_label.text = str(ceili((80.0 - production_val) / yield_product))
		product_progress_bar.value = production_val * 100.0 / 80.0

@onready var city_main_panel: PanelContainer = $CityMainPanelContainer
@onready var growth_turn_label: Label = $CityMainPanelContainer/HBoxContainer/GrowthTurnLabel
@onready var growth_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/GrowthProgressBar
@onready var level_label: Label = $CityMainPanelContainer/HBoxContainer/LevelLabel
@onready var capital_texture_rect: TextureRect = $CityMainPanelContainer/HBoxContainer/CapitalTextureRect
@onready var name_label: Label = $CityMainPanelContainer/HBoxContainer/NameLabel
@onready var product_texture_rect: TextureRect = $CityMainPanelContainer/HBoxContainer/ProductPanelContainer/ProductTextureRect
@onready var product_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/ProductProgressBar
@onready var product_turn_label: Label = $CityMainPanelContainer/HBoxContainer/ProductTurnLabel


func _ready() -> void:
	product_progress_bar.value = 0.0


func initiate() -> void:
	var city_do: CityDO = CityController.get_city_do(id)
	name_label.text = city_do.name
	global_position = MapController.map_shower.map_coord_to_global_position(city_do.coord)
	# 配置颜色
	set_main_color(PlayerController.get_current_player().main_color)
	set_second_color(PlayerController.get_current_player().second_color)
	# 是否首都
	capital_texture_rect.visible = city_do.capital
	# 绘制城市
	MapController.map_shower.paint_city(city_do.coord, 1)


func set_main_color(main_color: Color) -> void:
	city_main_panel.get("theme_override_styles/panel").set("bg_color", main_color)


func set_second_color(second_color: Color) -> void:
	level_label.add_theme_color_override("font_color", second_color)
	name_label.add_theme_color_override("font_color", second_color)


func _on_click_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print("_on_click_area_2d_input_event | clicked on city")
			# TODO: 可能的 bug - 如果在别处点击，这里释放的话，吞掉输入事件可能有 bug
			get_viewport().set_input_as_handled()
			city_clicked.emit(self)

