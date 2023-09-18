class_name MapEditorGUI
extends CanvasLayer


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

enum TerrainType {
	GRASS,
	GRASS_HILL,
	GRASS_MOUNTAIN,
	PLAIN,
	PLAIN_HILL,
	PLAIN_MOUNTAIN,
	DESERT,
	DESERT_HILL,
	DESERT_MOUNTAIN,
	TUNDRA,
	TUNDRA_HILL,
	TUNDRA_MOUNTAIN,
	SNOW,
	SNOW_HILL,
	SNOW_MOUNTAIN,
	SHORE,
	OCEAN,
}

enum PainterSize {
	SMALL,
	MID,
	BIG,
}

var place_mode: PlaceMode = PlaceMode.TERRAIN
var place_mode_group: ButtonGroup = null
var terrain_type: TerrainType = TerrainType.GRASS
var terrain_type_group: ButtonGroup = null
var painter_size: PainterSize = PainterSize.SMALL
var painter_size_group: ButtonGroup = null

@onready var info_label: Label = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TitleVBoxContainer/InfoLabel
@onready var rt_tab: TabContainer = $MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer
# 左上角的选择放置模式的按钮
@onready var terrain_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/TerrainButton
@onready var landscape_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/LandscapeButton
@onready var wonder_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/WonderButton
@onready var continent_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/ContinentButton
@onready var river_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/RiverButton
@onready var cliff_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/CliffButton
@onready var resource_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/ResourceButton
@onready var village_button: Button = $MarginContainer/LeftTopPanelContainer/VBoxContainer/GridContainer/VillageButton
# 右边选择笔刷大小的按钮
@onready var small_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/SmallButton"
@onready var mid_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/MidButton"
@onready var big_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/BigButton"
# 右边放置地形时的按钮
@onready var grass_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/GrassButton"
@onready var grass_hill_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/GrassHillButton"
@onready var grass_mountain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/GrassMountainButton"
@onready var plain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/PlainButton"
@onready var plain_hill_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/PlainHillButton"
@onready var plain_mountain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/PlainMountainButton"
@onready var desert_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/DesertButton"
@onready var desert_hill_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/DesertHillButton"
@onready var desert_mountain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/DesertMountainButton"
@onready var tundra_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/TundraButton"
@onready var tundra_hill_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/TundraHillButton"
@onready var tundra_mountain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/TundraMountainButton"
@onready var snow_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/SnowButton"
@onready var snow_hill_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/SnowHillButton"
@onready var snow_mountain_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/SnowMountainButton"
@onready var shore_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/ShoreButton"
@onready var ocean_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/TerrainGridContainer/OceanButton"


func _ready() -> void:
	place_mode_group = terrain_button.button_group
	place_mode_group.pressed.connect(handle_place_mode_group_pressed)
	terrain_type_group = grass_button.button_group
	terrain_type_group.pressed.connect(handle_terrain_type_group_pressed)
	painter_size_group = small_button.button_group
	painter_size_group.pressed.connect(handle_painter_size_group_pressed)


func handle_place_mode_group_pressed(button: BaseButton) -> void:
	match button:
		terrain_button:
			place_mode = PlaceMode.TERRAIN
		landscape_button:
			place_mode = PlaceMode.LANDSCAPE
		wonder_button:
			place_mode = PlaceMode.WONDER
		continent_button:
			place_mode = PlaceMode.CONTINENT
		river_button:
			place_mode = PlaceMode.RIVER
		cliff_button:
			place_mode = PlaceMode.CLIFF
		resource_button:
			place_mode = PlaceMode.RESOURCE
		village_button:
			place_mode = PlaceMode.VILLAGE
		_:
			printerr("wrong button in place mode group")


func handle_terrain_type_group_pressed(button: BaseButton) -> void:
	match button:
		grass_button:
			terrain_type = TerrainType.GRASS
		grass_hill_button:
			terrain_type = TerrainType.GRASS_HILL
		grass_mountain_button:
			terrain_type = TerrainType.GRASS_MOUNTAIN
		plain_button:
			terrain_type = TerrainType.PLAIN
		plain_hill_button:
			terrain_type = TerrainType.PLAIN_HILL
		plain_mountain_button:
			terrain_type = TerrainType.PLAIN_MOUNTAIN
		desert_button:
			terrain_type = TerrainType.DESERT
		desert_hill_button:
			terrain_type = TerrainType.DESERT_HILL
		desert_mountain_button:
			terrain_type = TerrainType.DESERT_MOUNTAIN
		tundra_button:
			terrain_type = TerrainType.TUNDRA
		tundra_hill_button:
			terrain_type = TerrainType.TUNDRA_HILL
		tundra_mountain_button:
			terrain_type = TerrainType.TUNDRA_MOUNTAIN
		snow_button:
			terrain_type = TerrainType.SNOW
		snow_hill_button:
			terrain_type = TerrainType.SNOW_HILL
		snow_mountain_button:
			terrain_type = TerrainType.SNOW_MOUNTAIN
		shore_button:
			terrain_type = TerrainType.SHORE
		ocean_button:
			terrain_type = TerrainType.OCEAN
		_:
			printerr("wrong button in terrain type group")


func handle_painter_size_group_pressed(button: BaseButton) -> void:
	match button:
		small_button:
			painter_size = PainterSize.SMALL
		mid_button:
			painter_size = PainterSize.MID
		big_button:
			painter_size = PainterSize.BIG
		_:
			printerr("wrong button in painter size group")


func get_rt_tab_status() -> TabStatus:
	if rt_tab.current_tab == 0:
		return TabStatus.PLACE
	else:
		return TabStatus.GRID


func set_info_label_text(text: String) -> void:
	info_label.text = text

