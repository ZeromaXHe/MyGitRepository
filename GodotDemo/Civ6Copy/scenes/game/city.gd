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


enum Building {
	PALACE, # 宫殿
}

var city_name: String
var coord: Vector2i
var player: Player
# 城市关联数组
var territory_coords: Array[Vector2i] = []
var sight_coords: Array[Vector2i] = []
var buildings: Array[Building] = []
# 城市数据
var capital: bool = false
var housing: int # 住房
var housing_needed: int # 需要的住房
var amenity: int # 宜居度
var defense: int = 13
# 城市累计量
var pop: int = 1
var food_sum: int = 0
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


func initiate(coord: Vector2i, map_shower: MapShower) -> void:
	# FIXME: 先随便给城市取个名字
	city_name = "罗马" + str(coord)
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
		buildings.append(Building.PALACE)
	capital_texture_rect.visible = capital
	# 绘制城市
	map_shower.paint_city(coord, 1)
	# 将城市记录到地图信息里
	MapService.get_map_tile_do_by_coord(coord).city = self
	# 将城市记录到玩家城市列表里
	player.cities.append(self)
	# 初始化城市领土（周围一圈）
	var territory_cells: Array[Vector2i] = map_shower.get_surrounding_cells(coord, 1, true).filter(MapService.is_in_map_tile)
	self.territory_coords.append_array(territory_cells)
	player.territory_border.paint_dash_border(territory_cells)
	# 城市视野（周围两格）
	var sight_cells: Array[Vector2i] = map_shower.get_surrounding_cells(coord, 2, true).filter(MapService.is_in_map_tile)
	self.sight_coords.append_array(sight_cells)
	for in_sight_coord in sight_cells:
		player.map_sight_info.in_sight(in_sight_coord)
	map_shower.paint_in_sight_tile_areas(sight_cells)
	# 初始化产量
	# TODO: 先写死，之后补逻辑
#	self.yield_culture = 1.4
#	self.yield_food = 4.3
#	self.yield_product = 5.7 * 4 # 测试稍微调整一下生产速度。估计当时截图也是选了“联机”速度，造单位会更快
#	self.yield_science = 3.1
#	self.yield_religion = 0.0
#	self.yield_gold = 5.7
	refresh_yield(map_shower)


func set_main_color(main_color: Color) -> void:
	city_main_panel.get("theme_override_styles/panel").set("bg_color", main_color)


func set_second_color(second_color: Color) -> void:
	level_label.add_theme_color_override("font_color", second_color)
	name_label.add_theme_color_override("font_color", second_color)


func refresh_yield(map_shower: MapShower) -> void:
	yield_culture = 0.0
	yield_food = 0.0
	yield_product = 0.0
	yield_science = 0.0
	yield_religion = 0.0
	yield_gold = 0.0
	# 地块产出
	for territory in territory_coords:
		# TODO: 需要根据公民分配的位置来判断是否加
		var yield_dto: YieldDTO = MapService.get_tile_yield(territory)
		yield_culture += yield_dto.culture
		yield_food += yield_dto.food
		yield_product += yield_dto.production
		yield_science += yield_dto.science
		yield_religion += yield_dto.religion
		yield_gold += yield_dto.gold
	# 建筑产出
	for building in buildings:
		match building:
			Building.PALACE:
				yield_culture += 1
				yield_gold += 5
				yield_product += 2
				yield_science += 2
	# 公民产出
	yield_science += 0.5 * pop


func update_product_val() -> void:
	if production_val + yield_product > 80.0:
		product_completed.emit(producing_unit_type, self)
		producing_unit_type = -1
		production_val += yield_product - 80.0
	else:
		production_val += yield_product


func _on_click_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			print("_on_click_area_2d_input_event | clicked on city")
			# TODO: 可能的 bug - 如果在别处点击，这里释放的话，吞掉输入事件可能有 bug
			get_viewport().set_input_as_handled()
			city_clicked.emit(self)

