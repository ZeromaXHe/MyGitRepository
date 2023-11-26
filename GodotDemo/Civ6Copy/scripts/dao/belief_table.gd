class_name BeliefTable
extends MySimSQL.EnumTable


enum Enum {
	# 万神殿信仰
	CITY_PATRON_GODDESS, # 城市守护女神
	EARTH_GODDESS, # 大地女神
	GOD_OF_THE_FORGE, # 锻造之神
	FERTILITY_RITES, # 丰产仪式
	GOD_OF_CRAFTSMEN, # 工匠之神
	GOD_OF_THE_SEA, # 海洋之神
	RIVER_GODDESS, # 河神
	DANCE_OF_THE_AURORA, # 极光之舞
	GODDESS_OF_FESTIVALS, # 节庆女神
	ORAL_TRADITION, # 口述传统
	LADY_OF_THE_REEDS_AND_MARSHES, # 芦苇和沼泽地里的夫人
	INITIATION_RITES, # 启蒙会
	DESERT_FOLKLORE, # 沙漠民俗
	SACRED_PATH, # 神圣道路
	DIVINE_SPARK, # 神圣之光
	STONE_CIRCLES, # 石圈
	GODDESS_OF_THE_HARVEST, # 收获女神
	GOD_OF_THE_OPEN_SKY, # 天空之神
	GOD_OF_HEALING, # 愈合之神
	GOD_OF_WAR, # 战争之神
	MONUMENT_TO_THE_GODS, # 主神纪念碑
	RELIGIOUS_IDOLS, # 宗教偶像
	RELIGIOUS_SETTLEMENTS, # 宗教移民
	GODDESS_OF_THE_HUNT, # 狩猎女神
	# 祭祀信仰
	DAR_E_MEHR, # 拜火神庙
	PAGODA, # 宝塔
	CATHEDRAL, # 大教堂
	WAT, # 佛寺
	MEETING_HOUSE, # 礼拜堂
	MOSQUE, # 清真寺
	SYNAGOGUE, # 犹太教堂
	GURDWARA, # 谒师所
	STUPA, # 窣堵波
	# 信徒信仰
	FEED_THE_WORLD, # 哺育世界
	CHORAL_MUSIC, # 合唱圣歌
	DIVINE_INSPIRATION, # 神灵的启示
	RELIQUARIES, # 圣物箱
	WARRIOR_MONKS, # 武僧
	JESUIT_EDUCATION, # 耶稣会教育
	WORK_ETHIC, # 职业道德
	RELIGIOUS_COMMUNITY, # 宗教社区
	ZEN_MEDITATION, # 禅修
	# 创始人信仰
	PILGRIMAGE, # 朝圣
	STEWARDSHIP, # 管理工作
	PAPAL_PRIMACY, # 教皇权威
	CHURCH_PROPERTY, # 教会财产
	CROSS_CULTURAL_DIALOGUE, # 跨文化对话
	LAY_MINISTRY, # 民间宗教团
	WORLD_CHURCH, # 普世教会
	TITHE, # 什一税
	RELIGIOUS_UNITY, # 宗教统一
	# 强化信仰
	MISSIONARY_ZEAL, # 传教热忱
	SCRIPTURE, # 经文
	BURIAL_GROUNDS, # 埋骨之地
	HOLY_ORDER, # 神圣采购
	JUST_WAR, # 十字军
	DEFENDER_OF_FAITH, # 信仰护卫者
	ITINERANT_PREACHERS, # 巡回传教士
	MONASTIC_ISOLATION, # 与世隔绝
	RELIGIOUS_COLONIZATION, # 宗教殖民
}

enum Type {
	PANTHEON, # 万神殿信仰
	SACRIFICE, # 祭祀信仰
	BELIEVER, # 信徒信仰
	FOUNDER, # 创始人信仰
	ENHANCEMENT, # 强化信仰
}


func _init() -> void:
	super._init()
	elem_type = BeliefDO
	
	for k in Enum.keys():
		var do := BeliefDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.CITY_PATRON_GODDESS:
				do.view_name = "城市守护女神"
				do.type = Type.PANTHEON
			Enum.CITY_PATRON_GODDESS:
				do.view_name = "城市守护女神"
				do.type = Type.PANTHEON
			Enum.EARTH_GODDESS:
				do.view_name = "大地女神"
				do.type = Type.PANTHEON
			Enum.GOD_OF_THE_FORGE:
				do.view_name = "锻造之神"
				do.type = Type.PANTHEON
			Enum.FERTILITY_RITES:
				do.view_name = "丰产仪式"
				do.type = Type.PANTHEON
			Enum.GOD_OF_CRAFTSMEN:
				do.view_name = "工匠之神"
				do.type = Type.PANTHEON
			Enum.GOD_OF_THE_SEA:
				do.view_name = "海洋之神"
				do.type = Type.PANTHEON
			Enum.RIVER_GODDESS:
				do.view_name = "河神"
				do.type = Type.PANTHEON
			Enum.DANCE_OF_THE_AURORA:
				do.view_name = "极光之舞"
				do.type = Type.PANTHEON
			Enum.GODDESS_OF_FESTIVALS:
				do.view_name = "节庆女神"
				do.type = Type.PANTHEON
			Enum.ORAL_TRADITION:
				do.view_name = "口述传统"
				do.type = Type.PANTHEON
			Enum.LADY_OF_THE_REEDS_AND_MARSHES:
				do.view_name = "芦苇和沼泽地里的夫人"
				do.type = Type.PANTHEON
			Enum.INITIATION_RITES:
				do.view_name = "启蒙会"
				do.type = Type.PANTHEON
			Enum.DESERT_FOLKLORE:
				do.view_name = "沙漠民俗"
				do.type = Type.PANTHEON
			Enum.SACRED_PATH:
				do.view_name = "神圣道路"
				do.type = Type.PANTHEON
			Enum.DIVINE_SPARK:
				do.view_name = "神圣之光"
				do.type = Type.PANTHEON
			Enum.STONE_CIRCLES:
				do.view_name = "石圈"
				do.type = Type.PANTHEON
			Enum.GODDESS_OF_THE_HARVEST:
				do.view_name = "收获女神"
				do.type = Type.PANTHEON
			Enum.GOD_OF_THE_OPEN_SKY:
				do.view_name = "天空之神"
				do.type = Type.PANTHEON
			Enum.GOD_OF_HEALING:
				do.view_name = "愈合之神"
				do.type = Type.PANTHEON
			Enum.GOD_OF_WAR:
				do.view_name = "战争之神"
				do.type = Type.PANTHEON
			Enum.MONUMENT_TO_THE_GODS:
				do.view_name = "主神纪念碑"
				do.type = Type.PANTHEON
			Enum.RELIGIOUS_IDOLS:
				do.view_name = "宗教偶像"
				do.type = Type.PANTHEON
			Enum.RELIGIOUS_SETTLEMENTS:
				do.view_name = "宗教移民"
				do.type = Type.PANTHEON
			Enum.GODDESS_OF_THE_HUNT:
				do.view_name = "狩猎女神"
				do.type = Type.PANTHEON
			Enum.DAR_E_MEHR:
				do.view_name = "拜火神庙"
				do.type = Type.SACRIFICE
			Enum.PAGODA:
				do.view_name = "宝塔"
				do.type = Type.SACRIFICE
			Enum.CATHEDRAL:
				do.view_name = "大教堂"
				do.type = Type.SACRIFICE
			Enum.WAT:
				do.view_name = "佛寺"
				do.type = Type.SACRIFICE
			Enum.MEETING_HOUSE:
				do.view_name = "礼拜堂"
				do.type = Type.SACRIFICE
			Enum.MOSQUE:
				do.view_name = "清真寺"
				do.type = Type.SACRIFICE
			Enum.SYNAGOGUE:
				do.view_name = "犹太教堂"
				do.type = Type.SACRIFICE
			Enum.GURDWARA:
				do.view_name = "谒师所"
				do.type = Type.SACRIFICE
			Enum.STUPA:
				do.view_name = "窣堵波"
				do.type = Type.SACRIFICE
			Enum.FEED_THE_WORLD:
				do.view_name = "哺育世界"
				do.type = Type.BELIEVER
			Enum.CHORAL_MUSIC:
				do.view_name = "合唱圣歌"
				do.type = Type.BELIEVER
			Enum.DIVINE_INSPIRATION:
				do.view_name = "神灵的启示"
				do.type = Type.BELIEVER
			Enum.RELIQUARIES:
				do.view_name = "圣物箱"
				do.type = Type.BELIEVER
			Enum.WARRIOR_MONKS:
				do.view_name = "武僧"
				do.type = Type.BELIEVER
			Enum.JESUIT_EDUCATION:
				do.view_name = "耶稣会教育"
				do.type = Type.BELIEVER
			Enum.WORK_ETHIC:
				do.view_name = "职业道德"
				do.type = Type.BELIEVER
			Enum.RELIGIOUS_COMMUNITY:
				do.view_name = "宗教社区"
				do.type = Type.BELIEVER
			Enum.ZEN_MEDITATION:
				do.view_name = "禅修"
				do.type = Type.BELIEVER
			Enum.PILGRIMAGE:
				do.view_name = "朝圣"
				do.type = Type.FOUNDER
			Enum.STEWARDSHIP:
				do.view_name = "管理工作"
				do.type = Type.FOUNDER
			Enum.PAPAL_PRIMACY:
				do.view_name = "教皇权威"
				do.type = Type.FOUNDER
			Enum.CHURCH_PROPERTY:
				do.view_name = "教会财产"
				do.type = Type.FOUNDER
			Enum.CROSS_CULTURAL_DIALOGUE:
				do.view_name = "跨文化对话"
				do.type = Type.FOUNDER
			Enum.LAY_MINISTRY:
				do.view_name = "民间宗教团"
				do.type = Type.FOUNDER
			Enum.WORLD_CHURCH:
				do.view_name = "普世教会"
				do.type = Type.FOUNDER
			Enum.TITHE:
				do.view_name = "什一税"
				do.type = Type.FOUNDER
			Enum.RELIGIOUS_UNITY:
				do.view_name = "宗教统一"
				do.type = Type.FOUNDER
			Enum.MISSIONARY_ZEAL:
				do.view_name = "传教热忱"
				do.type = Type.ENHANCEMENT
			Enum.SCRIPTURE:
				do.view_name = "经文"
				do.type = Type.ENHANCEMENT
			Enum.BURIAL_GROUNDS:
				do.view_name = "埋骨之地"
				do.type = Type.ENHANCEMENT
			Enum.HOLY_ORDER:
				do.view_name = "神圣采购"
				do.type = Type.ENHANCEMENT
			Enum.JUST_WAR:
				do.view_name = "十字军"
				do.type = Type.ENHANCEMENT
			Enum.DEFENDER_OF_FAITH:
				do.view_name = "信仰护卫者"
				do.type = Type.ENHANCEMENT
			Enum.ITINERANT_PREACHERS:
				do.view_name = "巡回传教士"
				do.type = Type.ENHANCEMENT
			Enum.MONASTIC_ISOLATION:
				do.view_name = "与世隔绝"
				do.type = Type.ENHANCEMENT
			Enum.RELIGIOUS_COLONIZATION:
				do.view_name = "宗教殖民"
				do.type = Type.ENHANCEMENT
		super.init_insert(do)
