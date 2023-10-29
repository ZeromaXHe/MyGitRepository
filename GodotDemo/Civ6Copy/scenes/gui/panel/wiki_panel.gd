class_name WikiPanel
extends PanelContainer


# 选中的顶端按钮
var chosen_top_btn: Button = null
# 顶端按钮组
@onready var concept_btn: Button = $MainVBoxContainer/BtnHBoxContainer/ConceptButton
@onready var culture_leader_btn: Button = $MainVBoxContainer/BtnHBoxContainer/CultureLeaderButton
@onready var city_state_btn: Button = $MainVBoxContainer/BtnHBoxContainer/CityStateButton
@onready var region_btn: Button = $MainVBoxContainer/BtnHBoxContainer/RegionButton
@onready var building_btn: Button = $MainVBoxContainer/BtnHBoxContainer/BuildingButton
@onready var wonder_project_btn: Button = $MainVBoxContainer/BtnHBoxContainer/WonderProjectButton
@onready var unit_btn: Button = $MainVBoxContainer/BtnHBoxContainer/UnitButton
@onready var power_up_btn: Button = $MainVBoxContainer/BtnHBoxContainer/PowerUpButton
@onready var great_person_btn: Button = $MainVBoxContainer/BtnHBoxContainer/GreatPersonButton
@onready var technology_btn: Button = $MainVBoxContainer/BtnHBoxContainer/TechnologyButton
@onready var municipality_btn: Button = $MainVBoxContainer/BtnHBoxContainer/MunicipalityButton
@onready var policy_btn: Button = $MainVBoxContainer/BtnHBoxContainer/PolicyButton
@onready var religon_btn: Button = $MainVBoxContainer/BtnHBoxContainer/ReligonButton
@onready var terrain_landscape_btn: Button = $MainVBoxContainer/BtnHBoxContainer/TerrainLandscapeButton
@onready var resource_btn: Button = $MainVBoxContainer/BtnHBoxContainer/ResourceButton
@onready var facility_route_btn: Button = $MainVBoxContainer/BtnHBoxContainer/FacilityRouteButton
@onready var governer_btn: Button = $MainVBoxContainer/BtnHBoxContainer/GovernerButton
@onready var historical_time_btn: Button = $MainVBoxContainer/BtnHBoxContainer/HistoricalTimeButton
# 左边按钮树
@onready var left_tree: Tree = $MainVBoxContainer/MainHBoxContainer/LeftVBoxContainer/LeftScrollContainer/LeftTree
# 右边滚动条栏
@onready var right_scroll_container: ScrollContainer = $MainVBoxContainer/MainHBoxContainer/RightVBoxContainer/RightPanelContainer/RightScrollContainer


func _ready() -> void:
	concept_btn.button_group.pressed.connect(handle_top_btn_group_pressed)
	chosen_top_btn = concept_btn
	init_concept_tree()


func init_concept_tree() -> void:
	# print("initing concept tree...")
	left_tree.clear()
	var root: TreeItem = left_tree.create_item()
	var child1_start: TreeItem = left_tree.create_item(root)
	child1_start.set_text(0, "开始")
	var child2_rise_and_fall = left_tree.create_item(root)
	child2_rise_and_fall.set_text(0, "迭起兴衰")
	var subchild2_1_historical_time = left_tree.create_item(child2_rise_and_fall)
	subchild2_1_historical_time.set_text(0, "历史时刻")


func init_terrain_landscape_tree() -> void:
	# print("initing terrain landscape tree...")
	left_tree.clear()
	var root: TreeItem = left_tree.create_item()
	var child1_intro: TreeItem = left_tree.create_item(root)
	child1_intro.set_text(0, "简介")
	
	var child2_terrain = left_tree.create_item(root)
	child2_terrain.set_text(0, "地形")
	child2_terrain.collapsed = true
	var subchild2_1_grass = left_tree.create_item(child2_terrain)
	subchild2_1_grass.set_text(0, "草原")
	var subchild2_2_grass_hill = left_tree.create_item(child2_terrain)
	subchild2_2_grass_hill.set_text(0, "草原（丘陵）")
	var subchild2_3_tundra = left_tree.create_item(child2_terrain)
	subchild2_3_tundra.set_text(0, "冻土")
	var subchild2_4_tundra_hill = left_tree.create_item(child2_terrain)
	subchild2_4_tundra_hill.set_text(0, "冻土（丘陵）")
	var subchild2_5_shore_and_lake = left_tree.create_item(child2_terrain)
	subchild2_5_shore_and_lake.set_text(0, "海岸与湖泊")
	var subchild2_6_ocean = left_tree.create_item(child2_terrain)
	subchild2_6_ocean.set_text(0, "海洋")
	var subchild2_7_plain = left_tree.create_item(child2_terrain)
	subchild2_7_plain.set_text(0, "平原")
	var subchild2_8_plain_hill = left_tree.create_item(child2_terrain)
	subchild2_8_plain_hill.set_text(0, "平原（丘陵）")
	var subchild2_9_desert = left_tree.create_item(child2_terrain)
	subchild2_9_desert.set_text(0, "沙漠")
	var subchild2_10_desert_hill = left_tree.create_item(child2_terrain)
	subchild2_10_desert_hill.set_text(0, "沙漠（丘陵）")
	var subchild2_11_mountain = left_tree.create_item(child2_terrain)
	subchild2_11_mountain.set_text(0, "山脉")
	var subchild2_12_snow = left_tree.create_item(child2_terrain)
	subchild2_12_snow.set_text(0, "雪地")
	var subchild2_13_snow_hill = left_tree.create_item(child2_terrain)
	subchild2_13_snow_hill.set_text(0, "雪地（丘陵）")
	
	var child3_landscape = left_tree.create_item(root)
	child3_landscape.set_text(0, "地貌")
	child3_landscape.collapsed = true
	var subchild3_1_ice = left_tree.create_item(child3_landscape)
	subchild3_1_ice.set_text(0, "冰")
	var subchild3_2_grass_flood = left_tree.create_item(child3_landscape)
	subchild3_2_grass_flood.set_text(0, "草原泛滥平原")
	
	var child4_natural_wonder = left_tree.create_item(root)
	child4_natural_wonder.set_text(0, "自然奇观")
	child4_natural_wonder.collapsed = true
	var subchild4_1_eyjafjallajokull = left_tree.create_item(child4_natural_wonder)
	subchild4_1_eyjafjallajokull.set_text(0, "艾雅法拉火山")
	
	left_tree.item_selected.connect(handle_terrain_landscape_tree_item_selected)
	


func handle_terrain_landscape_tree_item_selected() -> void:
	for child in right_scroll_container.get_children():
		child.queue_free()
	match (left_tree.get_selected().get_text(0)):
		"简介":
			right_scroll_container.add_child(load("res://scenes/gui/panel/wiki_pages/terrain_landscape_introduction_page.tscn").instantiate())
		"草原":
			right_scroll_container.add_child(load("res://scenes/gui/panel/wiki_pages/terrain_landscape_grass_page.tscn").instantiate())


func handle_top_btn_group_pressed(button: BaseButton) -> void:
	if button == chosen_top_btn:
		return
	chosen_top_btn = button
	match button:
		concept_btn:
			init_concept_tree()
		terrain_landscape_btn:
			init_terrain_landscape_tree()
		_:
			printerr("unknow button or no need to handle")


## 按下右上角的 X
func _on_close_button_pressed() -> void:
	self.visible = false
