class_name CityService


static func create_city(coord: Vector2i) -> CityDO:
	var city_do := CityDO.new()
	city_do.coord = coord
	# FIXME: 先随便给城市取个名字
	city_do.name = "罗马" + str(coord)
	var player_do: PlayerDO = PlayerService.get_current_player()
	city_do.player_id = player_do.id
	# 是否首都
	if get_city_dos_of_player(player_do.id).is_empty():
		city_do.capital = true
	
	DatabaseUtils.city_tbl.insert(city_do)
	
	# 初始化城市领土（周围一圈）
	var territory_cells: Array[Vector2i] = MapController.map_shower \
			.get_surrounding_cells(city_do.coord, 1, true) \
			.filter(MapController.is_in_map_tile)
	for cell in territory_cells:
#		print("create_city | city: ", city_do.id, " claiming territory: ", cell)
		MapTileService.city_claim_territory(city_do.id, cell)
	PlayerController.player_view_dict[PlayerService.get_current_player_id()].territory_border.paint_dash_border(territory_cells)
	
	# 城市视野（周围两格）
	var sight_cells: Array[Vector2i] = MapController.map_shower \
			.get_surrounding_cells(city_do.coord, 2, true) \
			.filter(MapController.is_in_map_tile)
	for in_sight_coord in sight_cells:
		PlayerSightService.in_sight(in_sight_coord)
	MapController.map_shower.paint_in_sight_tile_areas(sight_cells)
	
	# 首都宫殿建筑
	if city_do.capital:
		CityBuildingService.city_build(city_do.id, CityBuildingTable.Building.PALACE)
	
	return city_do


static func choose_producing_unit(id: int, unit_type: UnitTypeTable.Type) -> void:
	DatabaseUtils.city_tbl.update_field_by_id(id, "producing_type", unit_type)


static func get_city_do(id: int) -> CityDO:
	return DatabaseUtils.city_tbl.query_by_id(id)


static func get_city_dos_of_player(player_id: int) -> Array:
	return DatabaseUtils.city_tbl.query_by_player_id(player_id)


static func get_city_yield(city_id: int) -> YieldDTO:
	var city_do: CityDO = CityService.get_city_do(city_id)
	var city_yield := YieldDTO.new()
	# 地块产出
#	print("get_city_yield | start")
	var territories: Array = MapTileService.get_map_tile_dos_by_city(city_id)
#	print("get_city_yield | territories: ", territories)
	for territory in territories:
		# TODO: 需要根据公民分配的位置来判断是否加
		var tile_do := territory as MapTileDO 
#		print("get_city_yield | calcing tile yield coord: ", tile_do.coord)
		var yield_dto: YieldDTO = MapController.get_tile_yield(tile_do.coord)
		city_yield.culture += yield_dto.culture
		city_yield.food += yield_dto.food
		city_yield.production += yield_dto.production
		city_yield.science += yield_dto.science
		city_yield.religion += yield_dto.religion
		city_yield.gold += yield_dto.gold
	# 建筑产出
	var city_buildings: Array = CityBuildingService.get_buildings(city_id)
	for city_building in city_buildings:
#		print("get_city_yield | calcing building yield coord: ", city_building.building)
		match city_building.building:
			CityBuildingTable.Building.PALACE:
				city_yield.culture += 1
				city_yield.gold += 5
				city_yield.production += 2
				city_yield.science += 2
	# 公民产出
	city_yield.science += 0.5 * city_do.pop
	return city_yield


static func is_next_need_product(city: CityDO) -> bool:
	return city.producing_type == -1


static func update_product_val(id: int) -> void:
	var city_do: CityDO = get_city_do(id)
	var city_yield: YieldDTO = get_city_yield(id)
	# TODO: 暂时妥协的逻辑
	var city: City = CityController.city_view_dict[id]
	if city_do.production_sum + city_yield.production > 80.0:
		city.product_completed.emit(city_do.producing_type, city_do.coord)
		DatabaseUtils.city_tbl.update_field_by_id(id, "producing_type", -1)
		DatabaseUtils.city_tbl.update_field_by_id(id, "production_sum", city_do.production_sum + city_yield.production - 80.0)
	else:
		DatabaseUtils.city_tbl.update_field_by_id(id, "production_sum", city_do.production_sum + city_yield.production)

