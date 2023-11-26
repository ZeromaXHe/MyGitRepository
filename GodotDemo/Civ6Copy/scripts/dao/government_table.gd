class_name GovernmentTable
extends MySimSQL.EnumTable


enum Enum {
	AUTOCRACY, # 独裁统治
	FASCISM, # 法西斯主义
	COMMUNISM, # 共产主义
	CLASSICAL_REPUBLIC, # 古典共和
	OLIGARCHY, # 寡头政体
	MONARCHY, # 君主制
	DEMOCRACY, # 民主主义
	CHIEFDOM, # 酋邦
	MERCHANT_REPUBLIC, # 商人共和国
	THEOCRACY, # 神权政体
}


func _init() -> void:
	super._init()
	elem_type = GovernmentDO
	
	for k in Enum.keys():
		var do := GovernmentDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.AUTOCRACY:
				do.view_name = "独裁统治"
				do.military_slot = 1
				do.economy_slot = 1
				do.diplomacy_slot = 1
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
			Enum.FASCISM:
				do.view_name = "法西斯主义"
				do.military_slot = 4
				do.economy_slot = 1
				do.diplomacy_slot = 1
				do.wildcard_slot = 2
				do.required_civic = CivicTable.Enum.TOTALITARIANISM
			Enum.COMMUNISM:
				do.view_name = "共产主义"
				do.military_slot = 3
				do.economy_slot = 3
				do.diplomacy_slot = 1
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.CLASS_STRUGGLE
			Enum.CLASSICAL_REPUBLIC:
				do.view_name = "古典共和"
				do.economy_slot = 2
				do.diplomacy_slot = 1
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
			Enum.OLIGARCHY:
				do.view_name = "寡头政体"
				do.military_slot = 2
				do.economy_slot = 1
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
			Enum.MONARCHY:
				do.view_name = "君主制"
				do.military_slot = 2
				do.economy_slot = 1
				do.diplomacy_slot = 1
				do.wildcard_slot = 2
				do.required_civic = CivicTable.Enum.DIVINE_RIGHT
			Enum.DEMOCRACY:
				do.view_name = "民主主义"
				do.military_slot = 1
				do.economy_slot = 3
				do.diplomacy_slot = 2
				do.wildcard_slot = 2
				do.required_civic = CivicTable.Enum.SUFFRAGE
			Enum.CHIEFDOM:
				do.view_name = "酋邦"
				do.military_slot = 1
				do.economy_slot = 1
			Enum.MERCHANT_REPUBLIC:
				do.view_name = "商人共和国"
				do.military_slot = 1
				do.economy_slot = 2
				do.diplomacy_slot = 2
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.EXPLORATION
			Enum.THEOCRACY:
				do.view_name = "神权政体"
				do.military_slot = 2
				do.economy_slot = 2
				do.diplomacy_slot = 1
				do.wildcard_slot = 1
				do.required_civic = CivicTable.Enum.REFORMED_CHURCH
		super.init_insert(do)
