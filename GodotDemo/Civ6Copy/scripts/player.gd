class_name Player


const territory_border_scene: PackedScene = preload("res://scenes/game/territory_border_tile_map.tscn")

var p_name: String = "默认玩家名"
var main_color: Color = Color.BLACK:
	set(color):
		main_color = color
		(territory_border.material as ShaderMaterial).set_shader_parameter("to1", color)
var second_color: Color = Color.WHITE:
	set(color):
		second_color = color
		(territory_border.material as ShaderMaterial).set_shader_parameter("to2", color)
var map_sight_info: MapSightInfo = MapSightInfo.new()
var units: Array[Unit] = []
var cities: Array[City] = []
var territory_border: TerritoryBorderTileMap = territory_border_scene.instantiate()


func get_next_need_move_unit(unit: Unit = null, return_input: bool = true) -> Unit:
	if unit == null:
		var movable = units.filter(is_next_need_move)
		if movable.is_empty():
			return null
		return movable[0]
	
	if return_input and is_next_need_move(unit):
		return unit
	
	var idx = units.find(unit)
	if idx == -1:
		printerr("get_next_need_move_unit | unit unfound in units")
		return null
	var i = (idx + 1) % units.size()
	while i != idx:
		if is_next_need_move(units[i]):
			return units[i]
		i = (i + 1) % units.size()
	return null


func is_next_need_move(unit: Unit) -> bool:
	return unit.move_capability > 0 and not unit.skip_flag and not unit.sleep_flag


func refresh_units() -> void:
	for unit in units:
		unit.move_capability = unit.get_move_range()
		unit.skip_flag = false


func get_next_productable_city(city: City = null, return_input: bool = true) -> City:
	if city == null:
		var productable = cities.filter(is_next_need_product)
		if productable.is_empty():
			return null
		return productable[0]
	
	if return_input and is_next_need_product(city):
		return city
	
	var idx = cities.find(city)
	if idx == -1:
		printerr("get_next_productable_city | city unfound in cities")
		return null
	var i = (idx + 1) % cities.size()
	while i != idx:
		if is_next_need_product(cities[i]):
			return cities[i]
		i = (i + 1) % cities.size()
	return null


func is_next_need_product(city: City) -> bool:
	return city.producing_unit_type == -1


func update_citys_product_val() -> void:
	for city in cities:
		city.update_product_val()


class MapSightInfo:
	var sight_type_arr2d: Array = []
	var seen_dict: Dictionary = {}
	var unseen_dict: Dictionary = {}
	var in_sight_dict: Dictionary = {}
	
	
	func initialize(size: Vector2i) -> void:
		for i in range(size.x):
			sight_type_arr2d.append([])
			for j in range(size.y):
				sight_type_arr2d[i].append(Map.SightType.UNSEEN)
				unseen_dict[Vector2i(i, j)] = 1
	
	
	func get_in_sight_cells() -> Array[Vector2i]:
		var cells: Array[Vector2i] = []
		cells.append_array(in_sight_dict.keys())
		return cells
	
	
	func in_sight(coord: Vector2i) -> void:
		match sight_type_arr2d[coord.x][coord.y]:
			Map.SightType.SEEN:
				seen_dict.erase(coord)
			Map.SightType.UNSEEN:
				unseen_dict.erase(coord)
			Map.SightType.IN_SIGHT:
				in_sight_dict[coord] += 1
				return
		sight_type_arr2d[coord.x][coord.y] = Map.SightType.IN_SIGHT
		in_sight_dict[coord] = 1
	
	
	func out_sight(coord: Vector2i) -> void:
		if sight_type_arr2d[coord.x][coord.y] != Map.SightType.IN_SIGHT:
			return
		if in_sight_dict[coord] > 1:
			in_sight_dict[coord] -= 1
			return
		sight_type_arr2d[coord.x][coord.y] = Map.SightType.SEEN
		in_sight_dict.erase(coord)
		seen_dict[coord] = 1

