class_name Unit
extends Node2D


enum Category {
	GROUND_FORCE, # 地面部队
	SEA_FORCE, # 海上部队
	AIR_FORCE, # 空中部队
	ASSISTANT_FORCE, # 支援部队
	CITIZEN, # 平民
	TRADER, # 商人
	RELIGIOUS, # 宗教单位
}

enum Type {
	SETTLER, # 开拓者
	BUILDER, # 建造者
	SCOUT, # 侦察兵
	WARRIOR, # 勇士
}

const TYPE_TO_CATEGORY_DICT: Dictionary = {
	Type.SETTLER: Category.CITIZEN,
	Type.BUILDER: Category.CITIZEN,
	Type.SCOUT: Category.GROUND_FORCE,
	Type.WARRIOR: Category.GROUND_FORCE,
}

var category: Category
var type: Type
var player: Player

@onready var background: Sprite2D = $BackgroundSprite2D
@onready var icon: Sprite2D = $IconSprite2D


func initiate(type: Type, player: Player) -> void:
	self.type = type
	self.category = TYPE_TO_CATEGORY_DICT[type]
	self.player = player
	
	match self.type:
		Type.SETTLER:
			icon.texture = load("res://assets/civ6_origin/unit/webp_256x256/icon_unit_settler.webp")
			icon.scale = Vector2(0.2, 0.2)
		Type.BUILDER:
			icon.texture = load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_builder.webp")
			icon.scale = Vector2(0.8, 0.8)
		Type.SCOUT:
			icon.texture = load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_scout.webp")
			icon.scale = Vector2(0.8, 0.8)
		Type.WARRIOR:
			icon.texture = load("res://assets/civ6_origin/unit/webp_64x64/icon_unit_warrior.webp")
			icon.scale = Vector2(0.8, 0.8)
	
	match self.category:
		Category.CITIZEN:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_citizen_background.svg")
		Category.RELIGIOUS:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_religious_background.svg")
		Category.TRADER:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_trader_background.svg")
		Category.GROUND_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_ground_military_background.svg")
		Category.AIR_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_ground_military_background.svg")
		Category.SEA_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_sea_military_background.svg")
		Category.ASSISTANT_FORCE:
			background.texture = load("res://assets/self_made_svg/unit_background/unit_assistant_background.svg")
	
	background.modulate = player.main_color
	icon.modulate = player.second_color
