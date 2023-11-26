class_name PolicyTable
extends MySimSQL.EnumTable


enum Enum {
	# 军事政策
	DEFENSE_OF_MOTHERLAND, # 保卫祖国
	NATIVE_CONQUEST, # 本土征服
	LIMES, # 边界
	GRANDE_ARMEE, # 大军团
	SURVEY, # 调查
	FEUDAL_CONTRACT, # 封建契约
	INTERNATIONAL_WATERS, # 公海
	FINEST_HOUR, # 光荣时刻
	NATIONAL_IDENTITY, # 国家认同
	MARITIME_INDUSTRIES, # 海运业
	LOGISTICS, # 后勤
	DISCIPLINE, # 纪律
	VETERANCY, # 经验
	MARTIAL_LAW, # 军事管制
	MILITARY_RESEARCH, # 军事研究
	BASTIONS, # 棱堡
	CHIVALRY, # 骑士精神
	PRESS_GANGS, # 强征入伍
	TOTAL_WAR, # 全面战争
	LEVEE_EN_MASSE, # 全民动员
	RAID, # 扫荡
	LIGHTNING_WARFARE, # 闪电战
	RETAINERS, # 侍从
	AGOGE, # 斯巴达教育
	PATRIOTIC_WAR, # 卫国战争
	SACK, # 洗劫
	MILITARY_FIRST, # 先军政策
	PROPAGANDA, # 宣传机构
	MANEUVER, # 演习
	INTEGRATED_SPACE_CELL, # 一体化空间机构
	STRATEGIC_AIR_FORCE, # 战略空军
	CONSCRIPTION, # 征兵
	PROFESSIONAL_ARMY, # 职业军队
	WARS_OF_RELIGION, # 宗教战争
	# 经济政策
	URBAN_PLANNING, # 城市规划
	TOWN_CHARTERS, # 城镇特许状
	GRAND_OPERA, # 大歌剧
	THIRD_ALTERNATIVE, # 第三选择
	ECOMMERCE, # 电子商务
	ILKUM, # 服役
	GOTHIC_ARCHITECTURE, # 哥特式建筑
	CRAFTSMEN, # 工匠
	PUBLIC_WORKS, # 公共工程
	PUBLIC_TRANSPORT, # 公共交通
	SIMULTANEUM, # 共享教堂
	MEDINA_QUARTER, # 古老城区
	NAVAL_INFRASTRUCTURE, # 海军基础设施
	COLLECTIVIZATION, # 集体化
	MERITOCRACY, # 精英政治
	ECONOMIC_UNION, # 经济同盟
	SCRIPTURE, # 经文
	GOD_KING, # 君主崇拜
	RATIONALISM, # 理性主义
	INSULAE, # 楼房
	TRADE_CONFEDERATION, # 贸易联盟
	AESTHETICS, # 美学
	SKYSCRAPERS, # 摩天大楼
	SERFDOM, # 农奴制
	CORVEE, # 强迫劳役
	TRIANGULAR_TRADE, # 三角贸易
	CARAVANSARIES, # 商队旅馆
	MARKET_ECONOMY, # 市场经济
	SPORTS_MEDIA, # 体育传媒
	LAND_SURVEYORS, # 土地测量员
	SATELLITE_BROADCASTS, # 卫星广播
	FIVE_YEAR_PLAN, # 五年计划
	NEW_DEAL, # 新政
	HERITAGE_TOURISM, # 遗产旅游
	ONLINE_COMMUNITIES, # 在线社区
	EXPROPRIATION, # 征收
	COLONIZATION, # 殖民
	COLONIAL_OFFICES, # 殖民地办事处
	COLONIAL_TAXES, # 殖民地税收
	RESOURCE_MANAGEMENT, # 资源管理
	NATURAL_PHILOSOPHY, # 自然哲学
	FREE_MARKET, # 自由市场
	LIBERALISM, # 自由主义
	RELIGIOUS_ORDERS, # 宗教教派
	# 外交政策
	CONTAINMENT, # 遏制
	INTERNATIONAL_SPACE_AGENCY, # 国际宇航局
	NUCLEAR_ESPIONAGE, # 核间谍
	COLLECTIVE_ACTIVISM, # 集体行动主义
	POLICE_STATE, # 警察国度
	CRYPTOGRAPHY, # 密码学
	ARSENAL_OF_DEMOCRACY, # 民主军械库
	GUNBOAT_DIPLOMACY, # 炮舰外交
	MACHIAVELLIANISM, # 权术主义
	MERCHANT_CONFEDERATION, # 商人联盟
	RAJ, # 统治
	DIPLOMATIC_LEAGUE, # 外交联盟
	CHARISMATIC_LEADER, # 魅力型领袖
	# 伟人政策
	FRESCOES, # 壁画
	LAISSEZ_FAIRE, # 不干涉主义
	INVENTION, # 发明
	INSPIRATION, # 鼓舞
	NAVIGATION, # 航海
	STRATEGOS, # 将军
	SYMPHONIES, # 交响曲
	MILITARY_ORGANIZATION, # 军事组织
	TRAVELING_MERCHANTS, # 旅行商人
	NOBEL_PRIZE, # 诺贝尔奖
	REVELATION, # 启示
	LITERARY_TRADITION, # 文学传统
}

enum Type {
	MILITARY, # 军事政策
	ECONOMY, # 经济政策
	DIPLOMACY, # 外交政策
	GREAT_PERSON, # 伟人政策
}


func _init() -> void:
	super._init()
	elem_type = PolicyDO
	
	for k in Enum.keys():
		var do := PolicyDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.DEFENSE_OF_MOTHERLAND:
				do.view_name = "保卫祖国"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.CLASS_STRUGGLE
			Enum.NATIVE_CONQUEST:
				do.view_name = "本土征服"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.COLONIALISM
			Enum.LIMES:
				do.view_name = "边界"
				do.type = Type.MILITARY
				do.replaced_by = Enum.LIGHTNING_WARFARE
				do.required_civic = CivicTable.Enum.DEFENSIVE_TACTICS
			Enum.GRANDE_ARMEE:
				do.view_name = "大军团"
				do.type = Type.MILITARY
				do.replaced_by = Enum.MILITARY_FIRST
				do.required_civic = CivicTable.Enum.NATIONALISM
			Enum.SURVEY:
				do.view_name = "调查"
				do.type = Type.MILITARY
				do.replaced_by = Enum.NATIVE_CONQUEST
				do.required_civic = CivicTable.Enum.CODE_OF_LAWS
			Enum.FEUDAL_CONTRACT:
				do.view_name = "封建契约"
				do.type = Type.MILITARY
				do.replaced_by = Enum.GRANDE_ARMEE
				do.required_civic = CivicTable.Enum.FEUDALISM
			Enum.INTERNATIONAL_WATERS:
				do.view_name = "公海"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.COLD_WAR
			Enum.FINEST_HOUR:
				do.view_name = "光荣时刻"
				do.type = Type.MILITARY
				do.replaced_by = Enum.STRATEGIC_AIR_FORCE
				do.required_civic = CivicTable.Enum.SUFFRAGE
			Enum.NATIONAL_IDENTITY:
				do.view_name = "国家认同"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.NATIONALISM
			Enum.MARITIME_INDUSTRIES:
				do.view_name = "海运业"
				do.type = Type.MILITARY
				do.replaced_by = Enum.PRESS_GANGS
				do.required_civic = CivicTable.Enum.FOREIGN_TRADE
			Enum.LOGISTICS:
				do.view_name = "后勤"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.MERCANTILISM
			Enum.DISCIPLINE:
				do.view_name = "纪律"
				do.type = Type.MILITARY
				do.replaced_by = Enum.NATIVE_CONQUEST
				do.required_civic = CivicTable.Enum.CODE_OF_LAWS
			Enum.VETERANCY:
				do.view_name = "经验"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.MILITARY_TRAINING
			Enum.MARTIAL_LAW:
				do.view_name = "军事管制"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.TOTALITARIANISM
			Enum.MILITARY_RESEARCH:
				do.view_name = "军事研究"
				do.type = Type.MILITARY
				do.replaced_by = Enum.INTEGRATED_SPACE_CELL
				do.required_civic = CivicTable.Enum.URBANIZATION
			Enum.BASTIONS:
				do.view_name = "棱堡"
				do.type = Type.MILITARY
				do.replaced_by = Enum.PUBLIC_WORKS
				do.required_civic = CivicTable.Enum.DEFENSIVE_TACTICS
			Enum.CHIVALRY:
				do.view_name = "骑士精神"
				do.type = Type.MILITARY
				do.replaced_by = Enum.LIGHTNING_WARFARE
				do.required_civic = CivicTable.Enum.DIVINE_RIGHT
			Enum.PRESS_GANGS:
				do.view_name = "强征入伍"
				do.type = Type.MILITARY
				do.replaced_by = Enum.INTERNATIONAL_WATERS
				do.required_civic = CivicTable.Enum.EXPLORATION
			Enum.TOTAL_WAR:
				do.view_name = "全面战争"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.SCORCHED_EARTH
			Enum.LEVEE_EN_MASSE:
				do.view_name = "全民动员"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.MOBILIZATION
			Enum.RAID:
				do.view_name = "扫荡"
				do.type = Type.MILITARY
				do.replaced_by = Enum.TOTAL_WAR
				do.required_civic = CivicTable.Enum.MILITARY_TRAINING
			Enum.LIGHTNING_WARFARE:
				do.view_name = "闪电战"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.TOTALITARIANISM
			Enum.RETAINERS:
				do.view_name = "侍从"
				do.type = Type.MILITARY
				do.replaced_by = Enum.PROPAGANDA
				do.required_civic = CivicTable.Enum.CIVIL_SERVICE
			Enum.AGOGE:
				do.view_name = "斯巴达教育"
				do.type = Type.MILITARY
				do.replaced_by = Enum.FEUDAL_CONTRACT
				do.required_civic = CivicTable.Enum.CRAFTSMANSHIP
			Enum.PATRIOTIC_WAR:
				do.view_name = "卫国战争"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.CLASS_STRUGGLE
			Enum.SACK:
				do.view_name = "洗劫"
				do.type = Type.MILITARY
				do.replaced_by = Enum.TOTAL_WAR
				do.required_civic = CivicTable.Enum.MERCENARIES
			Enum.MILITARY_FIRST:
				do.view_name = "先军政策"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.RAPID_DEPLOYMENT
			Enum.PROPAGANDA:
				do.view_name = "宣传机构"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.MASS_MEDIA
			Enum.MANEUVER:
				do.view_name = "演习"
				do.type = Type.MILITARY
				do.replaced_by = Enum.CHIVALRY
				do.required_civic = CivicTable.Enum.MILITARY_TRADITION
			Enum.INTEGRATED_SPACE_CELL:
				do.view_name = "一体化空间机构"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.SPACE_RACE
			Enum.STRATEGIC_AIR_FORCE:
				do.view_name = "战略空军"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.GLOBALIZATION
			Enum.CONSCRIPTION:
				do.view_name = "征兵"
				do.type = Type.MILITARY
				do.replaced_by = Enum.LEVEE_EN_MASSE
				do.required_civic = CivicTable.Enum.STATE_WORKFORCE
			Enum.PROFESSIONAL_ARMY:
				do.view_name = "职业军队"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.MERCENARIES
			Enum.WARS_OF_RELIGION:
				do.view_name = "宗教战争"
				do.type = Type.MILITARY
				do.required_civic = CivicTable.Enum.REFORMED_CHURCH
			Enum.URBAN_PLANNING:
				do.view_name = "城市规划"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.COLONIAL_OFFICES
				do.required_civic = CivicTable.Enum.CODE_OF_LAWS
			Enum.TOWN_CHARTERS:
				do.view_name = "城镇特许状"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.ECONOMIC_UNION
				do.required_civic = CivicTable.Enum.GUILDS
			Enum.GRAND_OPERA:
				do.view_name = "大歌剧"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.OPERA_BALLET
			Enum.THIRD_ALTERNATIVE:
				do.view_name = "第三选择"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.TOTALITARIANISM
			Enum.ECOMMERCE:
				do.view_name = "电子商务"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.GLOBALIZATION
			Enum.ILKUM:
				do.view_name = "服役"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.SERFDOM
				do.required_civic = CivicTable.Enum.CRAFTSMANSHIP
			Enum.GOTHIC_ARCHITECTURE:
				do.view_name = "哥特式建筑"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.SKYSCRAPERS
				do.required_civic = CivicTable.Enum.DIVINE_RIGHT
			Enum.CRAFTSMEN:
				do.view_name = "工匠"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.FIVE_YEAR_PLAN
				do.required_civic = CivicTable.Enum.GUILDS
			Enum.PUBLIC_WORKS:
				do.view_name = "公共工程"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CIVIL_ENGINEERING
			Enum.PUBLIC_TRANSPORT:
				do.view_name = "公共交通"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.URBANIZATION
			Enum.SIMULTANEUM:
				do.view_name = "共享教堂"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.REFORMED_CHURCH
			Enum.MEDINA_QUARTER:
				do.view_name = "古老城区"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.NEW_DEAL
				do.required_civic = CivicTable.Enum.MEDIEVAL_FAIRES
			Enum.NAVAL_INFRASTRUCTURE:
				do.view_name = "海军基础设施"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.ECONOMIC_UNION
				do.required_civic = CivicTable.Enum.NAVAL_TRADITION
			Enum.COLLECTIVIZATION:
				do.view_name = "集体化"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CLASS_STRUGGLE
			Enum.MERITOCRACY:
				do.view_name = "精英政治"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CIVIL_SERVICE
			Enum.ECONOMIC_UNION:
				do.view_name = "经济同盟"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.SUFFRAGE
			Enum.SCRIPTURE:
				do.view_name = "经文"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.THEOLOGY
			Enum.GOD_KING:
				do.view_name = "君主崇拜"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.SCRIPTURE
				do.required_civic = CivicTable.Enum.CODE_OF_LAWS
			Enum.RATIONALISM:
				do.view_name = "理性主义"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.ENLIGHTENMENT
			Enum.INSULAE:
				do.view_name = "楼房"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.MEDINA_QUARTER
				do.required_civic = CivicTable.Enum.GAMES_RECREATION
			Enum.TRADE_CONFEDERATION:
				do.view_name = "贸易联盟"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.MARKET_ECONOMY
				do.required_civic = CivicTable.Enum.MERCENARIES
			Enum.AESTHETICS:
				do.view_name = "美学"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.SPORTS_MEDIA
				do.required_civic = CivicTable.Enum.MEDIEVAL_FAIRES
			Enum.SKYSCRAPERS:
				do.view_name = "摩天大楼"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CIVIL_ENGINEERING
			Enum.SERFDOM:
				do.view_name = "农奴制"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.PUBLIC_WORKS
				do.required_civic = CivicTable.Enum.FEUDALISM
			Enum.CORVEE:
				do.view_name = "强迫劳役"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.GOTHIC_ARCHITECTURE
				do.required_civic = CivicTable.Enum.STATE_WORKFORCE
			Enum.TRIANGULAR_TRADE:
				do.view_name = "三角贸易"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.ECOMMERCE
				do.required_civic = CivicTable.Enum.MERCANTILISM
			Enum.CARAVANSARIES:
				do.view_name = "商队旅馆"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.TRIANGULAR_TRADE
				do.required_civic = CivicTable.Enum.FOREIGN_TRADE
			Enum.MARKET_ECONOMY:
				do.view_name = "市场经济"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CAPITALISM
			Enum.SPORTS_MEDIA:
				do.view_name = "体育传媒"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.PROFESSIONAL_SPORTS
			Enum.LAND_SURVEYORS:
				do.view_name = "土地测量员"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.EXPROPRIATION
				do.required_civic = CivicTable.Enum.EARLY_EMPIRE
			Enum.SATELLITE_BROADCASTS:
				do.view_name = "卫星广播"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.SPACE_RACE
			Enum.FIVE_YEAR_PLAN:
				do.view_name = "五年计划"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CLASS_STRUGGLE
			Enum.NEW_DEAL:
				do.view_name = "新政"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.SUFFRAGE
			Enum.HERITAGE_TOURISM:
				do.view_name = "遗产旅游"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CULTURAL_HERITAGE
			Enum.ONLINE_COMMUNITIES:
				do.view_name = "在线社区"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.SOCIAL_MEDIA
			Enum.EXPROPRIATION:
				do.view_name = "征收"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.SCORCHED_EARTH
			Enum.COLONIZATION:
				do.view_name = "殖民"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.EXPROPRIATION
				do.required_civic = CivicTable.Enum.EARLY_EMPIRE
			Enum.COLONIAL_OFFICES:
				do.view_name = "殖民地办事处"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.EXPLORATION
			Enum.COLONIAL_TAXES:
				do.view_name = "殖民地税收"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.COLONIALISM
			Enum.RESOURCE_MANAGEMENT:
				do.view_name = "资源管理"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.CONSERVATION
			Enum.NATURAL_PHILOSOPHY:
				do.view_name = "自然哲学"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.FIVE_YEAR_PLAN
				do.required_civic = CivicTable.Enum.RECORDED_HISTORY
			Enum.FREE_MARKET:
				do.view_name = "自由市场"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.ENLIGHTENMENT
			Enum.LIBERALISM:
				do.view_name = "自由主义"
				do.type = Type.ECONOMY
				do.replaced_by = Enum.NEW_DEAL
				do.required_civic = CivicTable.Enum.ENLIGHTENMENT
			Enum.RELIGIOUS_ORDERS:
				do.view_name = "宗教教派"
				do.type = Type.ECONOMY
				do.required_civic = CivicTable.Enum.REFORMED_CHURCH
			Enum.CONTAINMENT:
				do.view_name = "遏制"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.COLD_WAR
			Enum.INTERNATIONAL_SPACE_AGENCY:
				do.view_name = "国际宇航局"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.GLOBALIZATION
			Enum.NUCLEAR_ESPIONAGE:
				do.view_name = "核间谍"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.NUCLEAR_PROGRAM
			Enum.COLLECTIVE_ACTIVISM:
				do.view_name = "集体行动主义"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.SOCIAL_MEDIA
			Enum.POLICE_STATE:
				do.view_name = "警察国度"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.IDEOLOGY
			Enum.CRYPTOGRAPHY:
				do.view_name = "密码学"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.COLD_WAR
			Enum.ARSENAL_OF_DEMOCRACY:
				do.view_name = "民主军械库"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.SUFFRAGE
			Enum.GUNBOAT_DIPLOMACY:
				do.view_name = "炮舰外交"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.TOTALITARIANISM
			Enum.MACHIAVELLIANISM:
				do.view_name = "权术主义"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.DIPLOMATIC_SERVICE
			Enum.MERCHANT_CONFEDERATION:
				do.view_name = "商人联盟"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.MEDIEVAL_FAIRES
			Enum.RAJ:
				do.view_name = "统治"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.COLONIALISM
			Enum.DIPLOMATIC_LEAGUE:
				do.view_name = "外交联盟"
				do.type = Type.DIPLOMACY
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
			Enum.CHARISMATIC_LEADER:
				do.view_name = "魅力型领袖"
				do.type = Type.DIPLOMACY
				do.replaced_by = Enum.GUNBOAT_DIPLOMACY
				do.required_civic = CivicTable.Enum.POLITICAL_PHILOSOPHY
			Enum.FRESCOES:
				do.view_name = "壁画"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.HUMANISM
			Enum.LAISSEZ_FAIRE:
				do.view_name = "不干涉主义"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.CAPITALISM
			Enum.INVENTION:
				do.view_name = "发明"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.HUMANISM
			Enum.INSPIRATION:
				do.view_name = "鼓舞"
				do.type = Type.GREAT_PERSON
				do.replaced_by = Enum.NOBEL_PRIZE
				do.required_civic = CivicTable.Enum.MYSTICISM
			Enum.NAVIGATION:
				do.view_name = "航海"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.NAVAL_TRADITION
			Enum.STRATEGOS:
				do.view_name = "将军"
				do.type = Type.GREAT_PERSON
				do.replaced_by = Enum.MILITARY_ORGANIZATION
				do.required_civic = CivicTable.Enum.MILITARY_TRADITION
			Enum.SYMPHONIES:
				do.view_name = "交响曲"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.OPERA_BALLET
			Enum.MILITARY_ORGANIZATION:
				do.view_name = "军事组织"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.SCORCHED_EARTH
			Enum.TRAVELING_MERCHANTS:
				do.view_name = "旅行商人"
				do.type = Type.GREAT_PERSON
				do.replaced_by = Enum.LAISSEZ_FAIRE
				do.required_civic = CivicTable.Enum.GUILDS
			Enum.NOBEL_PRIZE:
				do.view_name = "诺贝尔奖"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.NUCLEAR_PROGRAM
			Enum.REVELATION:
				do.view_name = "启示"
				do.type = Type.GREAT_PERSON
				do.replaced_by = Enum.INVENTION
				do.required_civic = CivicTable.Enum.MYSTICISM
			Enum.LITERARY_TRADITION:
				do.view_name = "文学传统"
				do.type = Type.GREAT_PERSON
				do.required_civic = CivicTable.Enum.DRAMA_POETRY
		super.init_insert(do)
