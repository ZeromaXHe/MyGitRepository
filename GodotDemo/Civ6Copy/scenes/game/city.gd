class_name City
extends Node2D


var city_name: String
var coord: Vector2i
var capital: bool = false
var level: int = 1
var growth: int = 0
var defense: int = 13
var player: Player
var territory_coords: Array[Vector2i] = []
var sight_coords: Array[Vector2i] = []

@onready var city_main_panel: PanelContainer = $CityMainPanelContainer
@onready var growth_turn_label: Label = $CityMainPanelContainer/HBoxContainer/GrowthTurnLabel
@onready var growth_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/GrowthProgressBar
@onready var level_label: Label = $CityMainPanelContainer/HBoxContainer/LevelLabel
@onready var capital_texture_rect: TextureRect = $CityMainPanelContainer/HBoxContainer/CapitalTextureRect
@onready var name_label: Label = $CityMainPanelContainer/HBoxContainer/NameLabel
@onready var product_texture_rect: TextureRect = $CityMainPanelContainer/HBoxContainer/ProductPanelContainer/ProductTextureRect
@onready var product_progress_bar: ProgressBar = $CityMainPanelContainer/HBoxContainer/ProductProgressBar
@onready var product_turn_label: Label = $CityMainPanelContainer/HBoxContainer/ProductTurnLabel


func initiate(coord: Vector2i, map: Map, map_shower: MapShower) -> void:
	# FIXME: 先随便给城市取个名字
	city_name = "罗马"
	name_label.text = city_name
	self.coord = coord
	self.global_position = map_shower.map_coord_to_global_position(coord)
	self.player = GlobalScript.get_current_player()
	# 配置颜色
	set_main_color(player.main_color)
	set_second_color(player.second_color)
	# 是否首都
	if player.cities.is_empty():
		capital = true
	capital_texture_rect.visible = capital
	# 绘制城市
	map_shower.paint_city(coord, 1) 
	# 将城市记录到地图信息里
	map.get_map_tile_info_at(coord).city = self
	# 将城市记录到玩家城市列表里
	player.cities.append(self)
	# 初始化城市领土（周围一圈）
	var territory_cells: Array[Vector2i] = map_shower.get_surrounding_cells(coord, 1, true).filter(map.is_in_map_tile)
	self.territory_coords.append_array(territory_cells)
	player.territory_border.paint_dash_border(territory_cells)
	# 城市视野（周围两格）
	var sight_cells: Array[Vector2i] = map_shower.get_surrounding_cells(coord, 2, true).filter(map.is_in_map_tile)
	self.sight_coords.append_array(sight_cells)
	for in_sight_coord in sight_cells:
		player.map_sight_info.in_sight(in_sight_coord)
	map_shower.paint_in_sight_tile_areas(sight_cells)


func set_main_color(main_color: Color) -> void:
	city_main_panel.get("theme_override_styles/panel").set("bg_color", main_color)


func set_second_color(second_color: Color) -> void:
	level_label.add_theme_color_override("font_color", second_color)
	name_label.add_theme_color_override("font_color", second_color)
