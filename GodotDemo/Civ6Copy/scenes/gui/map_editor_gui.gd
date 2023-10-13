class_name MapEditorGUI
extends CanvasLayer


signal restore_btn_pressed
signal cancel_btn_pressed

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

enum LandscapeType {
	ICE, # 冰
	FOREST, # 森林
	SWAMP, # 沼泽
	FLOOD, # 泛滥平原
	OASIS, # 绿洲
	RAINFOREST, # 雨林
}

enum ContinentType {
	AFRICA, # 非洲
	AMASIA, # 阿马西亚
	AMERICA, # 美洲
	ANTARCTICA, # 南极洲
	ARCTIC, # 北极大陆
	ASIA, # 亚洲
	ASIAMERICA, # 亚美大陆
	ATLANTICA, # 大西洋洲
	ATLANTIS, # 亚特兰蒂斯
	AUSTRALIA, # 澳大利亚
	AVALONIA, # 阿瓦隆尼亚
	AZANIA, # 阿扎尼亚
	BALTICA, # 波罗大陆
	CIMMERIA, # 辛梅利亚大陆
	COLUMBIA, # 哥伦比亚
	CONGO_CRATON, # 刚果克拉通
	EURAMERICA, # 欧美大陆
	EUROPE, # 欧洲
	GONDWANA, # 冈瓦那
	KALAHARI, # 喀拉哈里
	KAZAKHSTANIA, # 哈萨克大陆
	KENORLAND, # 凯诺兰
	KUMARI_KANDAM, # 古默里坎达
	LAURASIA, # 劳亚古陆
	LAURENTIA, # 劳伦古陆
	LEMURIA, # 利莫里亚 
	MU, # 穆大陆
	NENA, # 妮娜大陆
	NORTH_AMERICA, # 北美洲
	NOVOPANGAEA, # 新盘古大陆
	NUNA, # 努纳
	OCEANIA, # 大洋洲
	PANGAEA, # 盘古大陆
	PANGAEA_ULTIMA, # 终极盘古大陆
	PANNOTIA, # 潘诺西亚
	RODINIA, # 罗迪尼亚
	SIBERIA, # 西伯利亚
	SOUTH_AMERICA, # 南美洲
	TERRA_AUSTRALIS, # 未知的南方大陆
	UR, # 乌尔
	VAALBARA, # 瓦巴拉
	VENDIAN, # 文德期
	ZEALANDIA, # 西兰蒂亚
}

enum ResourceType {
	SILK, # 丝绸
	RELIC, # 历史遗迹
	COCOA_BEAN, # 可可豆
	COFFEE, # 咖啡
	MARBLE, # 大理石
	RICE, # 大米
	WHEAT, # 小麦
	TRUFFLE, # 松露
	ORANGE, # 柑橘
	DYE, # 染料
	COTTON, # 棉花
	MERCURY, # 水银
	WRECKAGE, # 海难遗迹
	TOBACCO, # 烟草
	COAL, # 煤
	INCENSE, # 熏香
	COW, # 牛
	JADE, # 玉
	CORN, # 玉米
	PEARL, # 珍珠
	FUR, # 皮草
	SALT, # 盐
	STONE, # 石头
	OIL, # 石油
	GYPSUM, # 石膏
	SALTPETER, # 硝石
	SUGAR, # 糖
	SHEEP, # 羊
	TEA, # 茶
	WINE, # 葡萄酒
	HONEY, # 蜂蜜
	CRAB, # 螃蟹
	IVORY, # 象牙
	DIAMOND, # 钻石
	URANIUM, # 铀
	IRON, # 铁
	COPPER, # 铜
	ALUMINIUM, # 铝
	SILVER, # 银
	SPICE, # 香料
	BANANA, # 香蕉
	HORSE, # 马
	FISH, # 鱼
	WHALE, # 鲸鱼
	DEER, # 鹿
}

var place_mode: PlaceMode = PlaceMode.TERRAIN
var place_mode_group: ButtonGroup = null
var terrain_type: TerrainType = TerrainType.GRASS
var terrain_type_group: ButtonGroup = null
var painter_size: PainterSize = PainterSize.SMALL
var painter_size_group: ButtonGroup = null
var landscape_type: LandscapeType = LandscapeType.ICE
var landscape_type_group: ButtonGroup = null
var continent_type: ContinentType = ContinentType.AFRICA
var resource_type: ResourceType = ResourceType.SILK
var resource_type_group: ButtonGroup = null

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
@onready var mid_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/MidButton"
@onready var big_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/BigButton"
# 恢复和取消按钮
@onready var restore_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/RestoreButton"
@onready var cancel_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/EditGridContainer/CancelButton"
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
@onready var relic_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/RelicButton"
@onready var cocoa_bean_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CocoaBeanButton"
@onready var coffee_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CoffeeButton"
@onready var marble_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/MarbleButton"
@onready var rice_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/RiceButton"
@onready var wheat_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/WheatButton"
@onready var truffle_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/TruffleButton"
@onready var orange_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/OrangeButton"
@onready var dye_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/DyeButton"
@onready var cotton_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CottonButton"
@onready var mercury_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/MercuryButton"
@onready var wreckage_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/WreckageButton"
@onready var tobacco_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/TobaccoButton"
@onready var coal_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CoalButton"
@onready var incense_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/IncenseButton"
@onready var cow_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CowButton"
@onready var jade_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/JadeButton"
@onready var corn_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CornButton"
@onready var pearl_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/PearlButton"
@onready var fur_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/FurButton"
@onready var salt_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SaltButton"
@onready var stone_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/StoneButton"
@onready var oil_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/OilButton"
@onready var gypsum_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/GypsumButton"
@onready var saltpeter_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SaltpeterButton"
@onready var sugar_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SugarButton"
@onready var sheep_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SheepButton"
@onready var tea_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/TeaButton"
@onready var wine_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/WineButton"
@onready var honey_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/HoneyButton"
@onready var crab_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CrabButton"
@onready var ivory_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/IvoryButton"
@onready var diamond_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/DiamondButton"
@onready var uranium_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/UraniumButton"
@onready var iron_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/IronButton"
@onready var copper_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/CopperButton"
@onready var aluminium_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/AluminiumButton"
@onready var silver_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SilverButton"
@onready var spice_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/SpiceButton"
@onready var banana_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/BananaButton"
@onready var horse_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/HorseButton"
@onready var fish_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/FishButton"
@onready var whale_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/WhaleButton"
@onready var deer_button: Button = $"MarginContainer/RightTopPanelContainer/RtVBoxContainer/TabContainer/放置/ScrollContainer/ResourceGridContainer/DeerButton"


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
	# 初始化右下角放置界面
	disvisible_all_place_container()
	terrain_container.visible = true
	# 初始化恢复和取消按钮
	restore_button.disabled = true
	cancel_button.disabled = true


func disvisible_all_place_container() -> void:
	terrain_container.visible = false
	landscape_container.visible = false
	wonder_container.visible = false
	continent_container.visible = false
	river_container.visible = false
	cliff_container.visible = false
	resource_container.visible = false
	village_container.visible = false


func handle_place_mode_group_pressed(button: BaseButton) -> void:
	disvisible_all_place_container()
	match button:
		terrain_button:
			place_mode = PlaceMode.TERRAIN
			terrain_container.visible = true
		landscape_button:
			place_mode = PlaceMode.LANDSCAPE
			landscape_container.visible = true
		wonder_button:
			place_mode = PlaceMode.WONDER
			wonder_container.visible = true
		continent_button:
			place_mode = PlaceMode.CONTINENT
			continent_container.visible = true
		river_button:
			place_mode = PlaceMode.RIVER
			river_container.visible = true
		cliff_button:
			place_mode = PlaceMode.CLIFF
			cliff_container.visible = true
		resource_button:
			place_mode = PlaceMode.RESOURCE
			resource_container.visible = true
		village_button:
			place_mode = PlaceMode.VILLAGE
			village_container.visible = true
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


func handle_landscape_type_group_pressed(button: BaseButton) -> void:
	match button:
		ice_button:
			landscape_type = LandscapeType.ICE
		forest_button:
			landscape_type = LandscapeType.FOREST
		swamp_button:
			landscape_type = LandscapeType.SWAMP
		flood_button:
			landscape_type = LandscapeType.FLOOD
		oasis_button:
			landscape_type = LandscapeType.OASIS
		rainforest_button:
			landscape_type = LandscapeType.RAINFOREST
		_:
			printerr("wrong button in landscape type group")


func handle_continent_item_selected(idx: int) -> void:
	# 直接默认大陆选择按钮的个数和枚举个数是一一对应的，暂时不校验
	continent_type = idx


func handle_resource_type_group_pressed(button: BaseButton) -> void:
	match button:
		silk_button:
			resource_type = ResourceType.SILK
		relic_button:
			resource_type = ResourceType.RELIC
		cocoa_bean_button:
			resource_type = ResourceType.COCOA_BEAN
		coffee_button:
			resource_type = ResourceType.COFFEE
		marble_button:
			resource_type = ResourceType.MARBLE
		rice_button:
			resource_type = ResourceType.RICE
		wheat_button:
			resource_type = ResourceType.WHEAT
		truffle_button:
			resource_type = ResourceType.TRUFFLE
		orange_button:
			resource_type = ResourceType.ORANGE
		dye_button:
			resource_type = ResourceType.DYE
		cotton_button:
			resource_type = ResourceType.COTTON
		mercury_button:
			resource_type = ResourceType.MERCURY
		wreckage_button:
			resource_type = ResourceType.WRECKAGE
		tobacco_button:
			resource_type = ResourceType.TOBACCO
		coal_button:
			resource_type = ResourceType.COAL
		incense_button:
			resource_type = ResourceType.INCENSE
		cow_button:
			resource_type = ResourceType.COW
		jade_button:
			resource_type = ResourceType.JADE
		corn_button:
			resource_type = ResourceType.CORN
		pearl_button:
			resource_type = ResourceType.PEARL
		fur_button:
			resource_type = ResourceType.FUR
		salt_button:
			resource_type = ResourceType.SALT
		stone_button:
			resource_type = ResourceType.STONE
		oil_button:
			resource_type = ResourceType.OIL
		gypsum_button:
			resource_type = ResourceType.GYPSUM
		saltpeter_button:
			resource_type = ResourceType.SALTPETER
		sugar_button:
			resource_type = ResourceType.SUGAR
		sheep_button:
			resource_type = ResourceType.SHEEP
		tea_button:
			resource_type = ResourceType.TEA
		wine_button:
			resource_type = ResourceType.WINE
		honey_button:
			resource_type = ResourceType.HONEY
		crab_button:
			resource_type = ResourceType.CRAB
		ivory_button:
			resource_type = ResourceType.IVORY
		diamond_button:
			resource_type = ResourceType.DIAMOND
		uranium_button:
			resource_type = ResourceType.URANIUM
		iron_button:
			resource_type = ResourceType.IRON
		copper_button:
			resource_type = ResourceType.COPPER
		aluminium_button:
			resource_type = ResourceType.ALUMINIUM
		silver_button:
			resource_type = ResourceType.SILVER
		spice_button:
			resource_type = ResourceType.SPICE
		banana_button:
			resource_type = ResourceType.BANANA
		horse_button:
			resource_type = ResourceType.HORSE
		fish_button:
			resource_type = ResourceType.FISH
		whale_button:
			resource_type = ResourceType.WHALE
		deer_button:
			resource_type = ResourceType.DEER
		_:
			printerr("wrong button in resource type group")


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


func _on_restore_button_pressed() -> void:
	restore_btn_pressed.emit()


func _on_cancel_button_pressed() -> void:
	cancel_btn_pressed.emit()
