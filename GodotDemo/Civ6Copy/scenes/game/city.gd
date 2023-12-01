class_name City
extends Node2D


signal city_clicked(city: City)
signal city_production_changed(city_id: int)
signal city_production_completed(unit_type: UnitTypeTable.Enum, city_coord: Vector2i)
signal city_name_button_pressed(city: City)
signal city_product_button_pressed(city: City)


const CITY_SCENE: PackedScene = preload("res://scenes/game/city.tscn")

static var id_dict: Dictionary = {}

var id: int:
	set(id_new):
		if id > 0:
			id_dict.erase(id)
		id = id_new
		if id_new > 0:
			id_dict[id] = self

@onready var city_main_panel: PanelContainer = $CityMainPanelContainer
@onready var growth_turn_label: Label = $CityMainPanelContainer/HBoxContainer/GrowthTurnLabel
@onready var growth_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/GrowthProgressBar
@onready var level_label: Label = $CityMainPanelContainer/HBoxContainer/LevelLabel
@onready var name_button: Button = $CityMainPanelContainer/HBoxContainer/CityNameButton
@onready var product_texture_rect: TextureRect = $CityMainPanelContainer/HBoxContainer/ProductPanelContainer/ProductTextureRect
@onready var product_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/ProductProgressBar
@onready var product_turn_label: Label = $CityMainPanelContainer/HBoxContainer/ProductTurnLabel


func _ready() -> void:
	product_progress_bar.value = 0.0


static func create_city(coord: Vector2i) -> City:
	var city_do: CityDO = CityService.create_city(coord)
	var city: City = CITY_SCENE.instantiate()
	city.id = city_do.id
	return city


func initiate() -> void:
	var city_do: CityDO = CityService.get_city_do(id)
	name_button.text = city_do.name
	# 是否首都
	if not city_do.capital:
		name_button.icon = null
	global_position = MapShower.singleton.map_coord_to_global_position(city_do.coord)
	# 配置颜色
	set_main_color(PlayerService.get_current_player().main_color)
	set_second_color(PlayerService.get_current_player().second_color)
	
	# 绘制城市
	MapShower.singleton.paint_city(city_do.coord, 1)


func set_main_color(main_color: Color) -> void:
	city_main_panel.get("theme_override_styles/panel").set("bg_color", main_color)


func set_second_color(second_color: Color) -> void:
	level_label.add_theme_color_override("font_color", second_color)
	name_button.add_theme_color_override("font_color", second_color)


func update_production_ui() -> void:
	var city_do: CityDO = CityService.get_city_do(id)
	# TODO: 暂时只用开拓者成本的计算
	product_progress_bar.value = city_do.production_sum * 100.0 / 80.0
	if city_do.producing_type == -1:
		product_texture_rect.texture = null
		product_turn_label.text = "-"
	else:
		product_texture_rect.texture = UnitService.get_unit_pic_webp_64x64(city_do.producing_type)
		# TODO: 需要缓存
		var yield_product = CityService.get_city_yield(id).production
		product_turn_label.text = str(ceili((80.0 - city_do.production_sum) / yield_product))


func _on_city_name_button_pressed() -> void:
	print("_on_city_name_button_pressed | city name button clicked")
	city_name_button_pressed.emit(self)


func _on_product_button_pressed() -> void:
	print("_on_product_button_pressed | city product button clicked")
	city_product_button_pressed.emit(self)


func _on_city_button_pressed() -> void:
	print("_on_city_button_pressed | city clicked")
	city_clicked.emit(self)
