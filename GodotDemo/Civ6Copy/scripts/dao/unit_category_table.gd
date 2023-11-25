class_name UnitCategoryTable
extends MySimSQL.EnumTable


enum Enum {
	# 地面部队
	RECON, # 侦察
	MELEE, # 近战
	RANGE, # 远程攻击
	LIGHT_CAVALRY, # 轻骑兵
	HEAVY_CAVALRY, # 重骑兵
	ANTI_CAVALRY, # 抗骑兵
	SIEGE, # 攻城
	# 海上部队
	NAVY_MELEE, # 海军近战
	NAVY_RANGE, # 海军远程攻击
	NAVY_ASSAULTER, # 海军袭击者
	NAVY_CARRIER, # 海军运输船
	# 空中部队
	AIR_FIGHTER, # 天空斗士
	AIR_BOMBER, # 空中轰炸
	# 支援
	SUPPORT, # 支援
	# 平民
	CITIZEN, # 平民
	GREAT_PERSON, # 伟人
	SPY, # 间谍
	TRADER, # 商人
	RELIGIOUS, # 宗教单位
}


func _init() -> void:
	super._init()
	elem_type = UnitCategoryDO
	
	for k in Enum.keys():
		var do := UnitCategoryDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.RECON:
				do.view_name = "侦察"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.MELEE:
				do.view_name = "近战"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.RANGE:
				do.view_name = "远程攻击"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.LIGHT_CAVALRY:
				do.view_name = "轻骑兵"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.HEAVY_CAVALRY:
				do.view_name = "重骑兵"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.ANTI_CAVALRY:
				do.view_name = "抗骑兵"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.SIEGE:
				do.view_name = "攻城"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.NAVY_MELEE:
				do.view_name = "海军近战"
				do.icon = "res://assets/self_made_svg/unit_background/unit_sea_military_background.svg"
			Enum.NAVY_RANGE:
				do.view_name = "海军远程攻击"
				do.icon = "res://assets/self_made_svg/unit_background/unit_sea_military_background.svg"
			Enum.NAVY_ASSAULTER:
				do.view_name = "海军袭击者"
				do.icon = "res://assets/self_made_svg/unit_background/unit_sea_military_background.svg"
			Enum.NAVY_CARRIER:
				do.view_name = "海军运输船"
				do.icon = "res://assets/self_made_svg/unit_background/unit_sea_military_background.svg"
			Enum.AIR_FIGHTER:
				do.view_name = "天空斗士"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.AIR_BOMBER:
				do.view_name = "空中轰炸"
				do.icon = "res://assets/self_made_svg/unit_background/unit_ground_military_background.svg"
			Enum.SUPPORT:
				do.view_name = "支援部队"
				do.icon = "res://assets/self_made_svg/unit_background/unit_assistant_background.svg"
			Enum.CITIZEN:
				do.view_name = "平民"
				do.icon = "res://assets/self_made_svg/unit_background/unit_citizen_background.svg"
			Enum.TRADER:
				do.view_name = "商人"
				do.icon = "res://assets/self_made_svg/unit_background/unit_trader_background.svg"
			Enum.RELIGIOUS:
				do.view_name = "宗教单位"
				do.icon = "res://assets/self_made_svg/unit_background/unit_religious_background.svg"
		super.init_insert(do)
