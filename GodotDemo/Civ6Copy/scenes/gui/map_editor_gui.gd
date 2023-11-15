class_name MapEditorGUI
extends CanvasLayer


signal restore_btn_pressed
signal cancel_btn_pressed
signal save_map_btn_pressed
signal place_continent_btn_pressed
signal place_other_btn_pressed
signal rt_tab_changed(tab: int)

enum TabStatus {
	PLACE,
	GRID,
}

enum PlaceMode {
	TERRAIN,
	LANDSCAPE,
	WONDER,
	CONTINENT,
	RIVER,
	CLIFF,
	RESOURCE,
	VILLAGE,
}

enum PainterSize {
	SMALL,
	MID,
	BIG,
}

const PAINTER_NAME_TO_SIZE_DICT: Dictionary = {
	"小笔刷": PainterSize.SMALL,
	"中笔刷": PainterSize.MID,
	"大笔刷": PainterSize.BIG,
}

var place_mode: PlaceMode = PlaceMode.TERRAIN
var place_mode_group: ButtonGroup = null
var terrain_type: TerrainTable.Terrain = TerrainTable.Terrain.GRASS
var terrain_type_group: ButtonGroup = null
var painter_size: PainterSize = PainterSize.SMALL
var painter_size_group: ButtonGroup = null
var landscape_type: LandscapeTable.Landscape = LandscapeTable.Landscape.ICE
var landscape_type_group: ButtonGroup = null
var continent_type: ContinentTable.Continent = ContinentTable.Continent.AFRICA
var resource_type: ResourceTable.ResourceType = ResourceTable.ResourceType.SILK
var resource_type_group: ButtonGroup = null

@onready var info_label: Label = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TitleVBoxContainer/InfoLabel
@onready var rt_tab: TabContainer = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer
# 右边格位面板相关
@onready var grid_coord_label: Label = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/格位/GridContainer/CoordLabel"
# 左上角的选择放置模式的按钮
@onready var terrain_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/TerrainButton
@onready var landscape_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/LandscapeButton
@onready var wonder_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/WonderButton
@onready var continent_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/ContinentButton
@onready var river_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/RiverButton
@onready var cliff_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/CliffButton
@onready var resource_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/ResourceButton
@onready var village_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/VillageButton
# 菜单界面相关
@onready var menu_overlay: PanelContainer = $MenuOverlay
# 右下角放置时的容器
@onready var terrain_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer"
@onready var landscape_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer"
@onready var wonder_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/WonderGridContainer"
@onready var continent_container: VBoxContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ContinentVBoxContainer"
@onready var river_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/RiverGridContainer"
@onready var cliff_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/CliffGridContainer"
@onready var resource_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer"
@onready var village_container: GridContainer = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/VillageGridContainer"
# 右边选择笔刷大小的按钮
@onready var small_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/SmallButton"
# 恢复和取消按钮
@onready var restore_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/RestoreButton"
@onready var cancel_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/CancelButton"
# 右边放置地形时的按钮
@onready var grass_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/GrassButton"
# 右边放置地貌时的按钮
@onready var ice_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/IceButton"
@onready var forest_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/ForestButton"
@onready var swamp_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/SwampButton"
@onready var flood_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/FloodButton"
@onready var oasis_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/OasisButton"
@onready var rainforest_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/LandscapeGridContainer/RainforestButton"
# 右边放置大陆时的按钮
@onready var continent_option_button: OptionButton = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ContinentVBoxContainer/ContinentOptionButton"
# 右边放置资源时的按钮
@onready var silk_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SilkButton"
# 鼠标悬停在地块上时显示的面板
@onready var mouse_hover_tile_panel: MouseHoverTilePanel = $MouseHoverTilePanel
@onready var mouse_hover_tile_label: Label = $MouseHoverTilePanel/MarginContainer/Label


func _ready() -> void:
	place_mode_group = terrain_button.button_group
	place_mode_group.pressed.connect(handle_place_mode_group_pressed)
	terrain_type_group = grass_button.button_group
	terrain_type_group.pressed.connect(handle_terrain_type_group_pressed)
	painter_size_group = small_button.button_group
	painter_size_group.pressed.connect(handle_painter_size_group_pressed)
	landscape_type_group = ice_button.button_group
	landscape_type_group.pressed.connect(handle_landscape_type_group_pressed)
	continent_option_button.item_selected.connect(handle_continent_item_selected)
	resource_type_group = silk_button.button_group
	resource_type_group.pressed.connect(handle_resource_type_group_pressed)
	# 初始为放置面板
	rt_tab.current_tab = 0
	rt_tab.tab_changed.connect(handle_rt_tab_changed)
	# 初始化右下角放置界面
	disvisible_all_place_container()
	terrain_container.visible = true
	# 初始化恢复和取消按钮
	restore_button.disabled = true
	cancel_button.disabled = true
	# 菜单界面不显示
	menu_overlay.visible = false
	# 鼠标悬停面板不显示
	hide_mouse_hover_tile_info()
	# 经常重新打开项目时，Git 提交里就显示这个值就没了，不是自定义（-1）了，就离谱
	# 为了避免哪天不小心提交了，所以强制指定一下
	mouse_hover_tile_panel.anchors_preset = -1


func disvisible_all_place_container() -> void:
	terrain_container.visible = false
	landscape_container.visible = false
	wonder_container.visible = false
	continent_container.visible = false
	river_container.visible = false
	cliff_container.visible = false
	resource_container.visible = false
	village_container.visible = false


func handle_rt_tab_changed(tab: int) -> void:
	rt_tab_changed.emit(tab)
	if tab == 0:
		# 切换放置，格位相关信息需要还原
		grid_coord_label.text = "无"
		# TODO: 其他格位信息


func update_grid_info(coord: Vector2i, tile_do: MapTileDO) -> void:
	grid_coord_label.text = str(coord)
	# TODO: 其他格位信息


func is_mouse_hover_info_shown() -> bool:
	return mouse_hover_tile_panel.visible


func show_mouse_hover_tile_info(map_coord: Vector2i, tile_do: MapTileDO) -> void:
	mouse_hover_tile_panel.show_info(map_coord, tile_do)


func hide_mouse_hover_tile_info() -> void:
	mouse_hover_tile_panel.hide_info()


func handle_place_mode_group_pressed(button: BaseButton) -> void:
	disvisible_all_place_container()
	match button:
		terrain_button:
			place_mode = PlaceMode.TERRAIN
			terrain_container.visible = true
			place_other_btn_pressed.emit()
		landscape_button:
			place_mode = PlaceMode.LANDSCAPE
			landscape_container.visible = true
			place_other_btn_pressed.emit()
		wonder_button:
			place_mode = PlaceMode.WONDER
			wonder_container.visible = true
			place_other_btn_pressed.emit()
		continent_button:
			place_mode = PlaceMode.CONTINENT
			continent_container.visible = true
			place_continent_btn_pressed.emit()
		river_button:
			place_mode = PlaceMode.RIVER
			river_container.visible = true
			place_other_btn_pressed.emit()
		cliff_button:
			place_mode = PlaceMode.CLIFF
			cliff_container.visible = true
			place_other_btn_pressed.emit()
		resource_button:
			place_mode = PlaceMode.RESOURCE
			resource_container.visible = true
			place_other_btn_pressed.emit()
		village_button:
			place_mode = PlaceMode.VILLAGE
			village_container.visible = true
			place_other_btn_pressed.emit()
		_:
			printerr("wrong button in place mode group")


func handle_terrain_type_group_pressed(button: BaseButton) -> void:
	var btn := button as Button
	var terrain_do: TerrainDO = DatabaseUtils.terrain_tbl.query_by_short_name(btn.text)
	if terrain_do == null:
		printerr("handle_terrain_type_group_pressed | wrong button in terrain type group")
		return
	terrain_type = TerrainTable.Terrain[terrain_do.enum_name]


func handle_painter_size_group_pressed(button: BaseButton) -> void:
	var btn := button as Button
	if not PAINTER_NAME_TO_SIZE_DICT.has(btn.text):
		printerr("handle_painter_size_group_pressed | wrong button in painter size group")
		return
	painter_size = PAINTER_NAME_TO_SIZE_DICT[btn.text]


func handle_landscape_type_group_pressed(button: BaseButton) -> void:
	var btn := button as Button
	var landscape_do: LandscapeDO = DatabaseUtils.landscape_tbl.query_by_short_name(btn.text)
	if landscape_do == null:
		printerr("handle_landscape_type_group_pressed | wrong button in landscape type group")
		return
	landscape_type = LandscapeTable.Landscape[landscape_do.enum_name]


func handle_continent_item_selected(idx: int) -> void:
	# 直接默认大陆选择按钮的个数和枚举个数是一一对应的，暂时不校验
	continent_type = idx + 1


func handle_resource_type_group_pressed(button: BaseButton) -> void:
	var btn := button as Button
	var resource_do: ResourceDO = DatabaseUtils.resource_tbl.query_by_short_name(btn.text)
	if resource_do == null:
		printerr("handle_resource_type_group_pressed | wrong button in resource type group")
		return
	resource_type = ResourceTable.ResourceType[resource_do.enum_name]


func get_painter_size_dist() -> int:
	match painter_size:
		PainterSize.SMALL:
			return 0
		PainterSize.MID:
			return 1
		PainterSize.BIG:
			return 2
		_:
			printerr("unknown painter size")
			return -1


func get_rt_tab_status() -> TabStatus:
	if rt_tab.current_tab == 0:
		return TabStatus.PLACE
	else:
		return TabStatus.GRID


func set_info_label_text(text: String) -> void:
	info_label.text = text


func set_restore_button_disable(b: bool) -> void:
	restore_button.disabled = b


func set_cancel_button_disable(b: bool) -> void:
	cancel_button.disabled = b


## 点击右边栏“恢复”按钮
func _on_restore_button_pressed() -> void:
	restore_btn_pressed.emit()


## 点击右边栏“取消”按钮
func _on_cancel_button_pressed() -> void:
	cancel_btn_pressed.emit()


## 点击右上角菜单按钮
func _on_menu_button_pressed() -> void:
	menu_overlay.visible = true


## 点击菜单页面“返回到地图”
func _on_return_button_pressed() -> void:
	menu_overlay.visible = false


## 点击菜单页面“返回主菜单”
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu/main_menu.tscn")


## 点击菜单页面“返回桌面”
func _on_desktop_button_pressed() -> void:
	get_tree().quit()


## 点击菜单页面“保存地图”
func _on_save_button_pressed() -> void:
	save_map_btn_pressed.emit()
