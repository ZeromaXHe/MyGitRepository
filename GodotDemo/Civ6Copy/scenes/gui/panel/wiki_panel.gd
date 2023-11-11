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


func disconnect_all_left_tree_signals() -> void:
	if left_tree.item_selected.is_connected(handle_concept_tree_item_selected):
		left_tree.item_selected.disconnect(handle_concept_tree_item_selected)
	if left_tree.item_selected.is_connected(handle_terrain_landscape_tree_item_selected):
		left_tree.item_selected.disconnect(handle_terrain_landscape_tree_item_selected)


func init_concept_tree() -> void:
	# print("initing concept tree...")
	left_tree.clear()
	disconnect_all_left_tree_signals()
	var root: TreeItem = left_tree.create_item()
	root.set_text(0, "根节点")
	var child1_intro: TreeItem = left_tree.create_item(root)
	child1_intro.set_text(0, "开始")
	
	var child2_mode = left_tree.create_item(root)
	child2_mode.set_text(0, "模式")
	child2_mode.collapsed = true
	var subchild2_1_monopolies = left_tree.create_item(child2_mode)
	subchild2_1_monopolies.set_text(0, "行业、垄断与公司")
	var subchild2_2_heros = left_tree.create_item(child2_mode)
	subchild2_2_heros.set_text(0, "英雄与传奇")
	var subchild2_3_tree_randomizer = left_tree.create_item(child2_mode)
	subchild2_3_tree_randomizer.set_text(0, "科技与市政随机模式")
	var subchild2_4_zombie_siege = left_tree.create_item(child2_mode)
	subchild2_4_zombie_siege.set_text(0, "丧尸之围")
	var subchild2_5_clans = left_tree.create_item(child2_mode)
	subchild2_5_clans.set_text(0, "蛮族氏族")
	var subchild2_6_clantype_melee_open = left_tree.create_item(child2_mode)
	subchild2_6_clantype_melee_open.set_text(0, "平原氏族")
	var subchild2_7_clantype_melee_forest = left_tree.create_item(child2_mode)
	subchild2_7_clantype_melee_forest.set_text(0, "林地氏族")
	var subchild2_8_clantype_melee_hills = left_tree.create_item(child2_mode)
	subchild2_8_clantype_melee_hills.set_text(0, "丘陵氏族")
	var subchild2_9_clantype_cavalry_open = left_tree.create_item(child2_mode)
	subchild2_9_clantype_cavalry_open.set_text(0, "漫游氏族")
	var subchild2_10_clantype_cavalry_jungle = left_tree.create_item(child2_mode)
	subchild2_10_clantype_cavalry_jungle.set_text(0, "丛林氏族")
	var subchild2_11_clantype_cavalry_chariot = left_tree.create_item(child2_mode)
	subchild2_11_clantype_cavalry_chariot.set_text(0, "战车氏族")
	var subchild2_12_clantype_naval = left_tree.create_item(child2_mode)
	subchild2_12_clantype_naval.set_text(0, "远航氏族")
	
	var child3_cities = left_tree.create_item(root)
	child3_cities.set_text(0, "城市")
	child3_cities.collapsed = true
	var subchild3_1_intro = left_tree.create_item(child3_cities)
	subchild3_1_intro.set_text(0, "介绍")
	var subchild3_2_how_to_build = left_tree.create_item(child3_cities)
	subchild3_2_how_to_build.set_text(0, "如何建造城市")
	var subchild3_3_where_to_build = left_tree.create_item(child3_cities)
	subchild3_3_where_to_build.set_text(0, "在哪里建造城市")
	var subchild3_4_development = left_tree.create_item(child3_cities)
	subchild3_4_development.set_text(0, "发展")
	var subchild3_5_food = left_tree.create_item(child3_cities)
	subchild3_5_food.set_text(0, "食物")
	var subchild3_6_housing = left_tree.create_item(child3_cities)
	subchild3_6_housing.set_text(0, "住房")
	var subchild3_7_water = left_tree.create_item(child3_cities)
	subchild3_7_water.set_text(0, "水")
	var subchild3_8_district = left_tree.create_item(child3_cities)
	subchild3_8_district.set_text(0, "区域")
	var subchild3_9_neighborhood_charm = left_tree.create_item(child3_cities)
	subchild3_9_neighborhood_charm.set_text(0, "社区和魅力")
	var subchild3_10_building = left_tree.create_item(child3_cities)
	subchild3_10_building.set_text(0, "建筑")
	var subchild3_11_wonder = left_tree.create_item(child3_cities)
	subchild3_11_wonder.set_text(0, "奇观")
	var subchild3_12_palace = left_tree.create_item(child3_cities)
	subchild3_12_palace.set_text(0, "宫殿")
	var subchild3_13_citizen = left_tree.create_item(child3_cities)
	subchild3_13_citizen.set_text(0, "公民")
	var subchild3_14_happiness = left_tree.create_item(child3_cities)
	subchild3_14_happiness.set_text(0, "幸福度")
	var subchild3_15_habitability_src = left_tree.create_item(child3_cities)
	subchild3_15_habitability_src.set_text(0, "宜居度来源")
	var subchild3_16_expert = left_tree.create_item(child3_cities)
	subchild3_16_expert.set_text(0, "专家")
	
	var child4_world = left_tree.create_item(root)
	child4_world.set_text(0, "世界")
	
	left_tree.item_selected.connect(handle_concept_tree_item_selected)
	left_tree.set_selected(child1_intro, 0)


func handle_concept_tree_item_selected() -> void:
	var selected: TreeItem = left_tree.get_selected()
	var parent_text: String = selected.get_parent().get_text(0)
	var text: String = selected.get_text(0)
	var new_page: VBoxContainer = null
	match parent_text:
		"根节点":
			match text:
				"开始":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_intro_page.tscn").instantiate()
				"模式":
					selected.collapsed = false
				"城市":
					selected.collapsed = false
		"模式":
			if text == "行业、垄断与公司":
				new_page = load("res://scenes/gui/panel/wiki_pages/concepts_monopolies_page.tscn").instantiate()
		"城市":
			match text:
				"介绍":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_intro_page.tscn").instantiate()
				"如何建造城市":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_how_to_build_page.tscn").instantiate()
				"在哪里建造城市":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_where_to_build_page.tscn").instantiate()
				"发展":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_development_page.tscn").instantiate()
				"食物":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_food_page.tscn").instantiate()
				"住房":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_housing_page.tscn").instantiate()
				"水":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_water_page.tscn").instantiate()
				"区域":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_district_page.tscn").instantiate()
				"社区和魅力":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_neighborhood_charm_page.tscn").instantiate()
				"建筑":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_building_page.tscn").instantiate()
				"奇观":
					new_page = load("res://scenes/gui/panel/wiki_pages/concepts_cities_wonder_page.tscn").instantiate()
	
	if new_page != null:
		for child in right_scroll_container.get_children():
			child.queue_free()
		right_scroll_container.add_child(new_page)


func init_terrain_landscape_tree() -> void:
	# print("initing terrain landscape tree...")
	left_tree.clear()
	disconnect_all_left_tree_signals()
	var root: TreeItem = left_tree.create_item()
	root.set_text(0, "根节点")
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
	left_tree.set_selected(child1_intro, 0)


func handle_terrain_landscape_tree_item_selected() -> void:
	var selected: TreeItem = left_tree.get_selected()
	var parent_text: String = selected.get_parent().get_text(0)
	var text: String = selected.get_text(0)
	var new_page: VBoxContainer = null
	match parent_text:
		"根节点":
			match text:
				"简介":
					new_page = load("res://scenes/gui/panel/wiki_pages/terrain_landscape_introduction_page.tscn").instantiate()
				"地形":
					selected.collapsed = false
				"地貌":
					selected.collapsed = false
				"自然奇观":
					selected.collapsed = false
		"地形":
			match text:
				"草原":
					new_page = load("res://scenes/gui/panel/wiki_pages/terrain_landscape_grass_page.tscn").instantiate()
	
	if new_page != null:
		for child in right_scroll_container.get_children():
			child.queue_free()
		right_scroll_container.add_child(new_page)


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
