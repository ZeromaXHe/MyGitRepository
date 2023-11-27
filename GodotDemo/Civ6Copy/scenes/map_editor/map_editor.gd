class_name MapEditor
extends Node2D


enum TileChangeType {
	TERRAIN,
	LANDSCAPE,
	VILLAGE,
	RESOURCE,
	CONTINENT,
}


# 左键点击开始时相对镜头的本地坐标
var _from_camera_position := Vector2(-1, -1)
# 格位模式下选择的图块
var _grid_chosen_coord: Vector2i = GlobalScript.NULL_COORD
# 鼠标悬浮的图块坐标和时间
var _mouse_hover_tile_coord: Vector2i = GlobalScript.NULL_COORD
var _mouse_hover_tile_time: float = 0
# 鼠标悬浮的边界坐标
var _mouse_hover_border_coord: Vector2i = GlobalScript.NULL_COORD
# 恢复和取消，记录操作的栈
var _before_step_stack: Array[PaintStep] = []
var _after_step_stack: Array[PaintStep] = []
# GUI 的引用
var gui: MapEditorGUI

@onready var map_shower: MapShower = $MapShower
@onready var camera: CameraManager = $Camera2D


func _ready() -> void:
	GameController.set_mode(GameController.Mode.MAP_EDITOR)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_viewport().set_input_as_handled()
			if event.is_pressed():
				# 选取图块
				_from_camera_position = camera.to_local(get_global_mouse_position())
			elif event.is_released():
				if camera.to_local(get_global_mouse_position()).distance_to(_from_camera_position) < 20:
					paint_map()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_released():
				get_viewport().set_input_as_handled()
				depaint_map()


func initiate(gui: MapEditorGUI) -> void:
	self.gui = gui
	
	gui.restore_btn_pressed.connect(handle_restore)
	gui.cancel_btn_pressed.connect(handle_cancel)
	gui.save_map_btn_pressed.connect(handle_save_map)
	# 控制大洲滤镜的显示与否
	gui.place_other_btn_pressed.connect(map_shower.hide_continent_layer)
	gui.place_continent_btn_pressed.connect(map_shower.show_continent_layer)
	# 切换放置和格位
	gui.rt_tab_changed.connect(handle_gui_rt_tab_changed)
	# 小地图相关
	gui.mini_map.click_on_tile.connect(handle_mini_map_clicked_on_tile)
	camera.set_minimap_transform_path(gui.mini_map.get_view_line().get_path())


func paint_grid_chosen_area(delta: float) -> void:
	var tile_moved: bool = handle_mouse_hover_tile(delta)
	var border_moved: bool = handle_mouse_hover_border(delta)
	if tile_moved or border_moved:
		paint_new_chosen_area()


func handle_mini_map_clicked_on_tile(coord: Vector2i) -> void:
	camera.global_position = map_shower.map_coord_to_global_position(coord)


func handle_save_map() -> void:
	MapController.save_map()


func handle_gui_rt_tab_changed(tab: int) -> void:
	_mouse_hover_tile_coord = GlobalScript.NULL_COORD
	_mouse_hover_border_coord = GlobalScript.NULL_COORD
	clear_pre_mouse_hover_tile_chosen()
	clear_pre_mouse_hover_border_chosen()


func handle_restore() -> void:
	if _after_step_stack.is_empty():
		printerr("之后操作为空，异常！")
		return
	var step: PaintStep = _after_step_stack.pop_back()
	if _after_step_stack.is_empty():
		gui.set_restore_button_disable(true)
	for change in step.changed_arr:
		if change.tile_change:
			match change.tile_change_type:
				TileChangeType.TERRAIN:
					map_shower.paint_tile(change.coord, change.after)
					ViewHolder.get_minimap_shower().paint_tile(change.coord, change.after)
				TileChangeType.LANDSCAPE:
					map_shower.paint_tile(change.coord, change.after)
				TileChangeType.VILLAGE:
					map_shower.paint_village(change.coord, change.after.village)
				TileChangeType.RESOURCE:
					map_shower.paint_resource(change.coord, change.after.resource)
				TileChangeType.CONTINENT:
					map_shower.paint_continent(change.coord, change.after.continent)
			# 恢复地图地块信息
			MapController.change_map_tile_info(change.coord, change.after)
		else:
			# 恢复 BorderTileMap 到操作后的状态
			map_shower.paint_border(change.coord, change.after_border.tile_type)
			ViewHolder.get_minimap_shower().paint_border(change.coord, change.after_border.tile_type)
			# 恢复地图地块信息
			MapController.change_border_tile_info(change.coord, change.after_border)
	# 把操作存到之前的取消栈中
	_before_step_stack.push_back(step)
	gui.set_cancel_button_disable(false)


func handle_cancel() -> void:
	if _before_step_stack.is_empty():
		printerr("历史操作为空，异常！")
		return
	var step: PaintStep = _before_step_stack.pop_back()
	if _before_step_stack.is_empty():
		gui.set_cancel_button_disable(true)
	for change in step.changed_arr:
		if change.tile_change:
			match change.tile_change_type:
				TileChangeType.TERRAIN:
					map_shower.paint_tile(change.coord, change.before)
					ViewHolder.get_minimap_shower().paint_tile(change.coord, change.before)
				TileChangeType.LANDSCAPE:
					map_shower.paint_tile(change.coord, change.before)
				TileChangeType.VILLAGE:
					map_shower.paint_village(change.coord, change.before.village)
				TileChangeType.RESOURCE:
					map_shower.paint_resource(change.coord, change.before.resource)
				TileChangeType.CONTINENT:
					map_shower.paint_continent(change.coord, change.before.continent)
			# 还原地图地块信息
			MapController.change_map_tile_info(change.coord, change.before)
		else:
			# 恢复 BorderTileMap 到操作前的状态
			map_shower.paint_border(change.coord, change.before_border.tile_type)
			ViewHolder.get_minimap_shower().paint_border(change.coord, change.before_border.tile_type)
			# 恢复地图地块信息
			MapController.change_border_tile_info(change.coord, change.before_border)
	# 把操作存到之后的恢复栈中
	_after_step_stack.push_back(step)
	gui.set_restore_button_disable(false)


func handle_mouse_hover_tile(delta: float) -> bool:
	var map_coord: Vector2i = map_shower.get_mouse_map_coord()
	if map_coord == _mouse_hover_tile_coord:
		_mouse_hover_tile_time += delta
		if not gui.is_mouse_hover_info_shown() and _mouse_hover_tile_time > 2 \
				and MapController.is_in_map_tile(map_coord):
			gui.show_mouse_hover_tile_info(map_coord)
		return false
	clear_pre_mouse_hover_tile_chosen()
	_mouse_hover_tile_coord = map_coord
	_mouse_hover_tile_time = 0
	gui.hide_mouse_hover_tile_info()
	return true


func clear_pre_mouse_hover_tile_chosen() -> void:
	# 擦除所有选择的地块图块
	map_shower.clear_tile_chosen()


func handle_mouse_hover_border(_delta: float) -> bool:
	var border_coord: Vector2i = map_shower.get_border_coord()
	if border_coord == _mouse_hover_border_coord:
		return false
	clear_pre_mouse_hover_border_chosen()
	_mouse_hover_border_coord = border_coord
	return true


func clear_pre_mouse_hover_border_chosen() -> void:
	# 清理所有选择的边界图块
	map_shower.clear_border_chosen()


func paint_new_chosen_area(renew: bool = false) -> void:
	var map_coord: Vector2i = map_shower.get_mouse_map_coord()
	var border_coord: Vector2i = map_shower.get_border_coord()
	# 只在放置模式下绘制鼠标悬浮地块
	if gui.get_rt_tab_status() != MapEditorGUI.TabStatus.PLACE:
		return
	if renew:
		clear_pre_mouse_hover_tile_chosen()
		clear_pre_mouse_hover_border_chosen()
	
	match gui.place_mode:
		MapEditorGUI.PlaceMode.RIVER:
			map_shower.paint_chosen_border_area(border_coord, MapBorderController.is_river_placeable)
		MapEditorGUI.PlaceMode.CLIFF:
			map_shower.paint_chosen_border_area(border_coord, MapBorderController.is_cliff_placeable)
		MapEditorGUI.PlaceMode.TERRAIN:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = MapController.get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				# 新增新图块
				map_shower.paint_tile_chosen_placeable(coord)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var placeable: Callable = func(x) -> bool: return LandscapeController.is_landscape_placeable(x, gui.landscape_type)
			map_shower.paint_chosen_tile_area(map_coord, placeable)
		MapEditorGUI.PlaceMode.VILLAGE:
			map_shower.paint_chosen_tile_area(map_coord, VillageController.is_village_placeable)
		MapEditorGUI.PlaceMode.RESOURCE:
			var placeable: Callable = func(x) -> bool: return ResourceController.is_resource_placeable(x, gui.resource_type)
			map_shower.paint_chosen_tile_area(map_coord, placeable)
		MapEditorGUI.PlaceMode.CONTINENT:
			var dist: int = gui.get_painter_size_dist()
			var new_inside: Array[Vector2i] = MapController.get_surrounding_cells(map_coord, dist, true)
			for coord in new_inside:
				map_shower.paint_chosen_tile_area(coord, ContinentController.is_continent_placeable)


func depaint_map() -> void:
	var step: PaintStep = PaintStep.new()
	match gui.place_mode:
		MapEditorGUI.PlaceMode.CLIFF:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if MapController.get_map_border_do_by_coord(border_coord).tile_type != MapBorderTable.Enum.CLIFF:
				return
			paint_border(border_coord, step, MapBorderTable.Enum.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if MapController.get_map_border_do_by_coord(border_coord).tile_type != MapBorderTable.Enum.RIVER:
				return
			paint_border(border_coord, step, MapBorderTable.Enum.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var tile_coord: Vector2i = map_shower.get_mouse_map_coord()
			if MapController.get_map_tile_do_by_coord(tile_coord).landscape == LandscapeTable.Enum.EMPTY:
				return
			paint_landscape(tile_coord, step, LandscapeTable.Enum.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var tile_coord: Vector2i = map_shower.get_mouse_map_coord()
			if not MapController.get_map_tile_do_by_coord(tile_coord).village:
				return
			paint_village(tile_coord, step, 0)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var tile_coord: Vector2i = map_shower.get_mouse_map_coord()
			if MapController.get_map_tile_do_by_coord(tile_coord).resource == ResourceTable.Enum.EMPTY:
				# FIXME: 4.1 现在的场景 TileMap bug，需要等待 4.2 发布解决。目前先打日志说明一下
#				print("tile map ", tile_coord, " is empty. (if you see a icon, it's because 4.1's bug. Wait for 4.2 update to fix it)")
				return
			paint_resource(tile_coord, step, ResourceTable.Enum.EMPTY)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
	save_paint_step(step)


func paint_map() -> void:
	# 格位模式下只绘制选择绿块
	if gui.get_rt_tab_status() == MapEditorGUI.TabStatus.GRID:
		var coord: Vector2i = map_shower.get_mouse_map_coord()
		map_shower.clear_tile_chosen()
		_grid_chosen_coord = coord
		map_shower.paint_tile_chosen_placeable(coord)
		gui.update_grid_info(coord, MapController.get_map_tile_do_by_coord(coord))
		return
	var step: PaintStep = PaintStep.new()
	match gui.place_mode:
		MapEditorGUI.PlaceMode.TERRAIN:
			var map_coord: Vector2i = map_shower.get_mouse_map_coord()
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = MapController.get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				# 超出地图范围的不处理
				if not MapController.is_in_map_tile(coord):
					continue
				if MapController.get_map_tile_do_by_coord(coord).terrain == gui.terrain_type:
					continue
				paint_terrain(coord, step, gui.terrain_type)
			# 围绕陆地地块绘制浅海
			if gui.terrain_type != TerrainTable.Enum.SHORE and gui.terrain_type != TerrainTable.Enum.OCEAN:
				var out_ring: Array[Vector2i] = MapController.get_surrounding_cells(map_coord, dist + 1, false)
				for coord in out_ring:
					# 超出地图范围的不处理
					if not MapController.is_in_map_tile(coord):
						continue
					# 仅深海需要改为浅海
					if MapController.get_map_tile_do_by_coord(coord).terrain != TerrainTable.Enum.OCEAN:
						continue
					paint_terrain(coord, step, TerrainTable.Enum.SHORE)
			# 如果地块是丘陵，需要在周围沿海边界放置悬崖
			if TerrainController.is_hill_land_terrain(gui.terrain_type):
				var borders: Array[Vector2i] = MapBorderController.get_surrounding_borders(map_coord, dist)
				for border in borders:
					if MapBorderController.is_cliff_placeable(border):
						paint_border(border, step, MapBorderTable.Enum.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.LANDSCAPE:
			var coord: Vector2i = map_shower.get_mouse_map_coord()
			if not LandscapeController.is_landscape_placeable(coord, gui.landscape_type):
				return
			if MapController.get_map_tile_do_by_coord(coord).landscape == gui.landscape_type:
				return
			paint_landscape(coord, step, gui.landscape_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.VILLAGE:
			var coord: Vector2i = map_shower.get_mouse_map_coord()
			if not VillageController.is_village_placeable(coord):
				return
			if MapController.get_map_tile_do_by_coord(coord).village:
				return
			paint_village(coord, step, 1)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RESOURCE:
			var coord: Vector2i = map_shower.get_mouse_map_coord()
			if not ResourceController.is_resource_placeable(coord, gui.resource_type):
				return
			if MapController.get_map_tile_do_by_coord(coord).resource == gui.resource_type:
				return
			paint_resource(coord, step, gui.resource_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CONTINENT:
			var map_coord: Vector2i = map_shower.get_mouse_map_coord()
			var dist: int = gui.get_painter_size_dist()
			var inside: Array[Vector2i] = MapController.get_surrounding_cells(map_coord, dist, true)
			for coord in inside:
				if not ContinentController.is_continent_placeable(coord):
					continue
				if MapController.get_map_tile_do_by_coord(coord).continent == gui.continent_type:
					continue
				paint_continent(coord, step, gui.continent_type)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.CLIFF:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if not MapBorderController.is_cliff_placeable(border_coord):
				return
			if MapController.get_map_border_do_by_coord(border_coord).tile_type == MapBorderTable.Enum.CLIFF:
				return
			# 绘制边界悬崖
			paint_border(border_coord, step, MapBorderTable.Enum.CLIFF)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
		MapEditorGUI.PlaceMode.RIVER:
			var border_coord: Vector2i = map_shower.get_border_coord()
			if not MapBorderController.is_river_placeable(border_coord):
				return
			if MapController.get_map_border_do_by_coord(border_coord).tile_type == MapBorderTable.Enum.RIVER:
				return
			# 绘制边界河流
			paint_border(border_coord, step, MapBorderTable.Enum.RIVER)
			# 强制重绘选择区域
			paint_new_chosen_area(true)
	
	save_paint_step(step)


func save_paint_step(step: PaintStep) -> void:
	if step.changed_arr.size() > 0:
		_before_step_stack.push_back(step)
		# 最多只记录 30 个历史操作
		if _before_step_stack.size() > 30:
			_before_step_stack.pop_front()
		gui.set_cancel_button_disable(false)
		# 每次操作后也就意味着不能向后恢复了
		_after_step_stack.clear()
		gui.set_restore_button_disable(true)


func paint_terrain(coord: Vector2i, step: PaintStep, terrain_type: TerrainTable.Enum):
	# 记录操作
	var change: PaintChange = build_change_of_tile(coord, TileChangeType.TERRAIN)
	change.after.terrain = terrain_type
	
	if change.before.landscape != LandscapeTable.Enum.EMPTY \
			and not LandscapeController.is_landscape_placeable_terrain(change.before.landscape, terrain_type):
		change.after.landscape = LandscapeTable.Enum.EMPTY
	if change.before.village and not VillageController.is_village_placeable_terrain(terrain_type):
		change.after.village = false
	
	if change.before.continent != ContinentTable.Enum.EMPTY \
			and not ContinentController.is_continent_placeable_terrain(terrain_type):
		change.after.continent = ContinentTable.Enum.EMPTY
	elif ContinentController.is_continent_placeable_terrain(terrain_type) and change.before.continent == ContinentTable.Enum.EMPTY:
		# 从海变陆时需要给个默认的大洲
		change.after.continent = gui.continent_type
	
	if change.before.resource != ResourceTable.Enum.EMPTY \
			and not ResourceController.is_resource_placeable_terrain_and_landscape(change.before.resource, terrain_type, change.after.landscape):
		change.after.resource = ResourceTable.Enum.EMPTY
	
	step.changed_arr.append(change)
	
	# 记录地图地块信息
	MapController.change_map_tile_info(coord, change.after)
	# 重新绘制整个 TileMap 地块
	map_shower.paint_tile(coord, change.after)
	ViewHolder.get_minimap_shower().paint_tile(coord, change.after)
	
	# 对周围一圈边界进行校验，不符合的边界需要重置为空
	var borders: Array[Vector2i] = MapBorderUtils.get_all_tile_border(coord, false)
	for border in borders:
		var border_do: MapBorderDO = MapController.get_map_border_do_by_coord(border)
		if border_do.tile_type == MapBorderTable.Enum.CLIFF:
			if not MapBorderController.is_cliff_placeable(border):
				paint_border(border, step, MapBorderTable.Enum.EMPTY)
		elif border_do.tile_type == MapBorderTable.Enum.RIVER:
			if not MapBorderController.is_river_placeable(border):
				paint_border(border, step, MapBorderTable.Enum.EMPTY)


func paint_landscape(tile_coord: Vector2i, step: PaintStep, type: LandscapeTable.Enum) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.LANDSCAPE)
	change.after.landscape = type
	
	if change.before.resource == ResourceTable.Enum.EMPTY \
			and not ResourceController.is_resource_placeable_terrain_and_landscape(change.before.resource, change.before.terrain, type):
		change.after.resource = ResourceTable.Enum.EMPTY
		map_shower.paint_resource(tile_coord, ResourceTable.Enum.EMPTY)
	
	step.changed_arr.append(change)
	# 记录地图地块信息
	MapController.change_map_tile_info(tile_coord, change.after)
	# 真正绘制地貌
	map_shower.paint_landscape(tile_coord, type)


func paint_village(tile_coord: Vector2i, step: PaintStep, type: int) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.VILLAGE)
	change.after.village = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	MapController.change_map_tile_info(tile_coord, change.after)
	# 真正绘制村庄
	map_shower.paint_village(tile_coord, type)


func paint_resource(tile_coord: Vector2i, step: PaintStep, type: ResourceTable.Enum) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.RESOURCE)
	change.after.resource = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	MapController.change_map_tile_info(tile_coord, change.after)
	# 真正绘制资源
	map_shower.paint_resource(tile_coord, type)


func paint_continent(tile_coord: Vector2i, step: PaintStep, type: ContinentTable.Enum) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_tile(tile_coord, TileChangeType.CONTINENT)
	change.after.continent = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	MapController.change_map_tile_info(tile_coord, change.after)
	# 真正绘制大洲
	map_shower.paint_continent(tile_coord, type)


func paint_border(border_coord: Vector2i, step: PaintStep, type: MapBorderTable.Enum) -> void:
	# 记录操作
	var change: PaintChange = build_change_of_border(border_coord)
	change.after_border.tile_type = type
	step.changed_arr.append(change)
	# 记录地图地块信息
	MapController.change_border_tile_info(border_coord, change.after_border)
	# 真正绘制边界
	map_shower.paint_border(border_coord, type)
	ViewHolder.get_minimap_shower().paint_border(border_coord, type)


func build_change_of_tile(tile_coord: Vector2i, type: TileChangeType) -> PaintChange:
	var change: PaintChange = PaintChange.new()
	change.coord = tile_coord
	change.tile_change = true
	change.tile_change_type = type
	change.before = MapController.get_map_tile_do_by_coord(tile_coord)
	change.after = change.before.clone()
	return change
	
	
func build_change_of_border(border_coord: Vector2i) -> PaintChange:
	var change: PaintChange = PaintChange.new()
	change.coord = border_coord
	change.tile_change = false
	change.before_border = MapController.get_map_border_do_by_coord(border_coord)
	change.after_border = change.before_border.clone()
	return change


class PaintStep extends RefCounted:
	var changed_arr: Array[PaintChange] = []


class PaintChange extends RefCounted:
	var coord: Vector2i
	var tile_change: bool
	var tile_change_type: TileChangeType = TileChangeType.TERRAIN
	var before: MapTileDO
	var after: MapTileDO
	var before_border: MapBorderDO
	var after_border: MapBorderDO

