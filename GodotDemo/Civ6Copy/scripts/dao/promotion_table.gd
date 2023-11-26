class_name PromotionTable
extends MySimSQL.EnumTable


enum Enum {
	# 攻城
	SHRAPNEL, # 榴霰弹
	SHELLS, # 炮弹
	FORWARD_OBSERVERS, # 前方观察员
	ADVANCED_RANGEFINDING, # 先进测距
	CREW_WEAPONS, # 重武器
	EXPERT_CREW, # 专家组
	GRAPE_SHOT, # 霰弹
	# 海军近战
	HELMSMAN, # 舵手
	AUXILIARY_SHIPS, # 辅助船
	RUTTER, # 航线海图
	CONVOY, # 护航队
	REINFORCED_HULL, # 加固船壳
	EMBOLON, # 楔形阵
	CREEPING_ATTACK, # 匍匐攻击
	# 海军袭击者
	BOARDING, # 登船
	OBSERVATION, # 观察
	WOLFPACK, # 狼群战术
	SWIFT_KEEL, # 龙骨改良
	LOOT, # 掠夺
	SILENT_RUNNING, # 无声运行
	HOMING_TORPEDOES, # 自导鱼雷
	# 海军远程攻击
	COINCIDENCE_RANGEFINDING, # 测距一致
	SUPPLY_FLEET, # 船舰补给
	BOMBARDMENT, # 轰炸
	PREPARATORY_FIRE, # 火力准备
	PROXIMITY_FUSES, # 近爆引管
	ROLLING_BARRAGE, # 徐进弹
	LINE_OF_BATTLE, # 战斗队形
	# 海军运输船
	SUPER_CARRIER, # 超级航空母舰
	FLIGHT_DECK, # 飞行甲板
	HANGAR_DECK, # 机库甲板
	DECK_CREWS, # 甲板专员
	ADVANCED_ENGINES, # 先进发动机
	FOLDING_WINGS, # 折翼
	SCOUT_PLANES, # 侦察飞机
	# 间谍活动
	DEMOLITIONS, # 爆破兵
	CAT_BURGLAR, # 飞贼
	ROCKET_SCIENTIST, # 火箭专家
	TECHNOLOGIST, # 技术专家
	QUARTERMASTER, # 军需官
	CON_ARTIST, # 骗子
	ACE_DRIVER, # 王牌驾驶员
	DISGUISE, # 掩饰
	GUERILLA_LEADER, # 游击队领袖
	SEDUCTION, # 诱惑
	LINGUIST, # 语言学家
	# 近战
	URBAN_WARFARE, # 城镇战
	TORTOISE, # 龟形盾
	ELITE_GUARD, # 精英卫队
	ZWEIHANDER, # 双手剑
	AMPHIBIOUS, # 水陆两栖
	COMMANDO, # 突击队
	BATTLECRY, # 战嚎
	# 抗骑兵
	SCHILTRON, # 长矛阵
	SQUARE, # 方阵
	ECHELON, # 梯队
	THRUST, # 突袭
	HOLD_THE_LINE, # 压阵
	CHOKE_POINTS, # 咽喉要道
	REDEPLOY, # 重新部署
	# 空中轰炸
	SUPERFORTRESS, # 超级堡垒
	BOX_FORMATION, # 方阵形式
	EVASIVE_MANEUVERS, # 机动规避
	CLOSE_AIR_SUPPORT, # 近距空中支援
	TORPEDO_BOMBER, # 鱼雷轰炸机
	LONG_RANGE, # 远程
	TACTICAL_MAINTENANCE, # 战术维护
	# 尼杭战士
	FAITH_FOR_VICTORIES, # 三叉戟
	NO_WOUNDED_PENALTY, # 锁子甲
	SUZERAIN_COMBAT_BONUS, # 铁护腕
	MOVEMENT_BONUS, # 铁头战靴
	FLANKED_BONUS, # 弯剑
	# 轻骑兵
	ESCORT_MOBILITY, # 护卫队机动性
	SPIKING_THE_GUNS, # 火药失效
	DOUBLE_ENVELOPMENT, # 两翼包围
	DEPREDATION, # 掠夺
	CAPARISON, # 马衣
	PURSUIT, # 追击
	COURSERS, # 追猎者
	# 天空斗士
	GROUND_CREWS, # 地勤人员
	DROP_TANKS, # 副油箱
	DOGFIGHTING, # 空中缠斗
	INTERCEPTOR, # 拦截机
	STRAFE, # 扫射
	TANK_BUSTER, # 坦克克星
	COCKPIT_ARMOR, # 座舱护甲
	# 武僧
	DANCING_CRANE, # 白鹤拳
	EXPLODING_PALMS, # 穿心掌
	DISCIPLES, # 弟子
	SWEEPING_WIND, # 凤舞拳
	TWILIGHT_VEIL, # 迷魂幕
	COBRA_STRIKE, # 蛇形拳
	SHADOW_STRIKE, # 无影拳
	# 远程攻击
	ARROW_STORM, # 风暴之箭
	EMPLACEMENT, # 炮台
	VOLLEY, # 齐射
	INCENDIARIES, # 燃烧弹
	EXPERT_MARKSMAN, # 神枪手
	SUPPRESSION, # 压制
	GARRISON, # 驻军
	# 侦察
	ALPINE, # 高山
	AMBUSH, # 埋伏
	SENTRY, # 哨兵
	SPYGLASS, # 望远镜
	CAMOUFLAGE, # 伪装
	GUERRILLA, # 游击队
	RANGER, # 游骑兵
	# 重骑兵
	CHARGE, # 冲锋
	ARMOR_PIERCING, # 穿透护甲
	REACTIVE_ARMOR, # 反应装甲
	ROUT, # 击溃
	MARAUDING, # 抢劫
	BREAKTHROUGH, # 突破
	BARDING, # 战马铠甲
	# 宗教传播
	DEBATER, # 辩论者
	PILGRIM, # 朝圣者
	TRANSLATOR, # 翻译员
	CHAPLAIN, # 牧师
	PROSELYTIZER, # 劝导者
	INDULGENCE_VENDOR, # 赎罪券小贩
	MARTYR, # 殉道者
	ORATOR, # 演说者
	HEATHEN_CONVERSION, # 异教徒信仰转变
}


func _init() -> void:
	super._init()
	elem_type = PromotionDO
	
	for k in Enum.keys():
		var do := PromotionDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.SHRAPNEL:
				do.view_name = "榴霰弹"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
				do.required_promotion = [Enum.GRAPE_SHOT] as Array[Enum]
			Enum.SHELLS:
				do.view_name = "炮弹"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
				do.required_promotion = [Enum.CREW_WEAPONS] as Array[Enum]
			Enum.FORWARD_OBSERVERS:
				do.view_name = "前方观察员"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
				do.required_promotion = [Enum.ADVANCED_RANGEFINDING, Enum.EXPERT_CREW] as Array[Enum]
			Enum.ADVANCED_RANGEFINDING:
				do.view_name = "先进测距"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
				do.required_promotion = [Enum.SHRAPNEL, Enum.SHELLS] as Array[Enum]
			Enum.CREW_WEAPONS:
				do.view_name = "重武器"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
			Enum.EXPERT_CREW:
				do.view_name = "专家组"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
				do.required_promotion = [Enum.SHRAPNEL, Enum.SHELLS] as Array[Enum]
			Enum.GRAPE_SHOT:
				do.view_name = "霰弹"
				do.unit_category = UnitCategoryTable.Enum.SIEGE
			Enum.HELMSMAN:
				do.view_name = "舵手"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
			Enum.AUXILIARY_SHIPS:
				do.view_name = "辅助船"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
				do.required_promotion = [Enum.REINFORCED_HULL, Enum.RUTTER] as Array[Enum]
			Enum.RUTTER:
				do.view_name = "航线海图"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
				do.required_promotion = [Enum.HELMSMAN] as Array[Enum]
			Enum.CONVOY:
				do.view_name = "护航队"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
				do.required_promotion = [Enum.REINFORCED_HULL, Enum.RUTTER] as Array[Enum]
			Enum.REINFORCED_HULL:
				do.view_name = "加固船壳"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
				do.required_promotion = [Enum.EMBOLON] as Array[Enum]
			Enum.EMBOLON:
				do.view_name = "楔形阵"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
			Enum.REINFORCED_HULL:
				do.view_name = "匍匐攻击"
				do.unit_category = UnitCategoryTable.Enum.NAVY_MELEE
				do.required_promotion = [Enum.AUXILIARY_SHIPS, Enum.CONVOY] as Array[Enum]
			Enum.BOARDING:
				do.view_name = "登船"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
			Enum.OBSERVATION:
				do.view_name = "观察"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.required_promotion = [Enum.SWIFT_KEEL] as Array[Enum]
			Enum.WOLFPACK:
				do.view_name = "狼群战术"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.required_promotion = [Enum.OBSERVATION, Enum.SILENT_RUNNING] as Array[Enum]
			Enum.SWIFT_KEEL:
				do.view_name = "龙骨改良"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.required_promotion = [Enum.LOOT, Enum.HOMING_TORPEDOES] as Array[Enum]
			Enum.LOOT:
				do.view_name = "掠夺"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
			Enum.SILENT_RUNNING:
				do.view_name = "无声运行"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.required_promotion = [Enum.HOMING_TORPEDOES] as Array[Enum]
			Enum.HOMING_TORPEDOES:
				do.view_name = "自导鱼雷"
				do.unit_category = UnitCategoryTable.Enum.NAVY_ASSAULTER
				do.required_promotion = [Enum.BOARDING, Enum.SWIFT_KEEL] as Array[Enum]
			Enum.COINCIDENCE_RANGEFINDING:
				do.view_name = "测距一致"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
				do.required_promotion = [Enum.SUPPLY_FLEET, Enum.PROXIMITY_FUSES] as Array[Enum]
			Enum.SUPPLY_FLEET:
				do.view_name = "船舰补给"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
				do.required_promotion = [Enum.PREPARATORY_FIRE, Enum.ROLLING_BARRAGE] as Array[Enum]
			Enum.BOMBARDMENT:
				do.view_name = "轰炸"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
			Enum.PREPARATORY_FIRE:
				do.view_name = "火力准备"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
				do.required_promotion = [Enum.LINE_OF_BATTLE] as Array[Enum]
			Enum.PROXIMITY_FUSES:
				do.view_name = "近爆引管"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
				do.required_promotion = [Enum.PREPARATORY_FIRE, Enum.ROLLING_BARRAGE] as Array[Enum]
			Enum.ROLLING_BARRAGE:
				do.view_name = "徐进弹"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
				do.required_promotion = [Enum.BOMBARDMENT] as Array[Enum]
			Enum.LINE_OF_BATTLE:
				do.view_name = "战斗队形"
				do.unit_category = UnitCategoryTable.Enum.NAVY_RANGE
			Enum.SUPER_CARRIER:
				do.view_name = "超级航空母舰"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.required_promotion = [Enum.FOLDING_WINGS, Enum.DECK_CREWS] as Array[Enum]
			Enum.FLIGHT_DECK:
				do.view_name = "飞行甲板"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
			Enum.HANGAR_DECK:
				do.view_name = "机库甲板"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.required_promotion = [Enum.FLIGHT_DECK] as Array[Enum]
			Enum.DECK_CREWS:
				do.view_name = "甲板专员"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.required_promotion = [Enum.ADVANCED_ENGINES, Enum.FOLDING_WINGS] as Array[Enum]
			Enum.ADVANCED_ENGINES:
				do.view_name = "先进发动机"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.required_promotion = [Enum.SCOUT_PLANES, Enum.HANGAR_DECK] as Array[Enum]
			Enum.FOLDING_WINGS:
				do.view_name = "折翼"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
				do.required_promotion = [Enum.HANGAR_DECK] as Array[Enum]
			Enum.SCOUT_PLANES:
				do.view_name = "侦察飞机"
				do.unit_category = UnitCategoryTable.Enum.NAVY_CARRIER
			Enum.DEMOLITIONS:
				do.view_name = "爆破兵"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.CAT_BURGLAR:
				do.view_name = "飞贼"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.ROCKET_SCIENTIST:
				do.view_name = "火箭专家"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.TECHNOLOGIST:
				do.view_name = "技术专家"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.QUARTERMASTER:
				do.view_name = "军需官"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.CON_ARTIST:
				do.view_name = "骗子"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.ACE_DRIVER:
				do.view_name = "王牌驾驶员"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.DISGUISE:
				do.view_name = "掩饰"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.GUERILLA_LEADER:
				do.view_name = "游击队领袖"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.SEDUCTION:
				do.view_name = "诱惑"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.LINGUIST:
				do.view_name = "语言学家"
				do.unit_category = UnitCategoryTable.Enum.SPY
			Enum.URBAN_WARFARE:
				do.view_name = "城镇战"
				do.unit_category = UnitCategoryTable.Enum.MELEE
				do.required_promotion = [Enum.COMMANDO, Enum.AMPHIBIOUS] as Array[Enum]
			Enum.TORTOISE:
				do.view_name = "龟形盾"
				do.unit_category = UnitCategoryTable.Enum.MELEE
			Enum.ELITE_GUARD:
				do.view_name = "精英卫队"
				do.unit_category = UnitCategoryTable.Enum.MELEE
				do.required_promotion = [Enum.ZWEIHANDER, Enum.URBAN_WARFARE] as Array[Enum]
			Enum.ZWEIHANDER:
				do.view_name = "双手剑"
				do.unit_category = UnitCategoryTable.Enum.MELEE
				do.required_promotion = [Enum.COMMANDO, Enum.AMPHIBIOUS] as Array[Enum]
			Enum.AMPHIBIOUS:
				do.view_name = "水陆两栖"
				do.unit_category = UnitCategoryTable.Enum.MELEE
				do.required_promotion = [Enum.TORTOISE, Enum.COMMANDO] as Array[Enum]
			Enum.COMMANDO:
				do.view_name = "突击队"
				do.unit_category = UnitCategoryTable.Enum.MELEE
				do.required_promotion = [Enum.BATTLECRY, Enum.AMPHIBIOUS] as Array[Enum]
			Enum.BATTLECRY:
				do.view_name = "战嚎"
				do.unit_category = UnitCategoryTable.Enum.MELEE
			Enum.SCHILTRON:
				do.view_name = "长矛阵"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.required_promotion = [Enum.THRUST] as Array[Enum]
			Enum.SQUARE:
				do.view_name = "方阵"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.required_promotion = [Enum.ECHELON] as Array[Enum]
			Enum.ECHELON:
				do.view_name = "梯队"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
			Enum.THRUST:
				do.view_name = "突袭"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
			Enum.HOLD_THE_LINE:
				do.view_name = "压阵"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.required_promotion = [Enum.REDEPLOY, Enum.CHOKE_POINTS] as Array[Enum]
			Enum.CHOKE_POINTS:
				do.view_name = "咽喉要道"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.required_promotion = [Enum.SQUARE, Enum.SCHILTRON] as Array[Enum]
			Enum.REDEPLOY:
				do.view_name = "重新部署"
				do.unit_category = UnitCategoryTable.Enum.ANTI_CAVALRY
				do.required_promotion = [Enum.SQUARE, Enum.SCHILTRON] as Array[Enum]
			Enum.SUPERFORTRESS:
				do.view_name = "超级堡垒"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
				do.required_promotion = [Enum.TACTICAL_MAINTENANCE, Enum.LONG_RANGE] as Array[Enum]
			Enum.BOX_FORMATION:
				do.view_name = "方阵形式"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
			Enum.EVASIVE_MANEUVERS:
				do.view_name = "机动规避"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
			Enum.CLOSE_AIR_SUPPORT:
				do.view_name = "近距空中支援"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
				do.required_promotion = [Enum.EVASIVE_MANEUVERS, Enum.BOX_FORMATION] as Array[Enum]
			Enum.TORPEDO_BOMBER:
				do.view_name = "鱼雷轰炸机"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
				do.required_promotion = [Enum.BOX_FORMATION, Enum.EVASIVE_MANEUVERS] as Array[Enum]
			Enum.LONG_RANGE:
				do.view_name = "远程"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
				do.required_promotion = [Enum.CLOSE_AIR_SUPPORT] as Array[Enum]
			Enum.TACTICAL_MAINTENANCE:
				do.view_name = "战术维护"
				do.unit_category = UnitCategoryTable.Enum.AIR_BOMBER
				do.required_promotion = [Enum.TORPEDO_BOMBER] as Array[Enum]
			Enum.FAITH_FOR_VICTORIES:
				do.view_name = "三叉戟"
				do.unit_category = UnitCategoryTable.Enum.LAHORE_NIHANG
			Enum.NO_WOUNDED_PENALTY:
				do.view_name = "锁子甲"
				do.unit_category = UnitCategoryTable.Enum.LAHORE_NIHANG
				do.required_promotion = [Enum.FAITH_FOR_VICTORIES, Enum.MOVEMENT_BONUS] as Array[Enum]
			Enum.SUZERAIN_COMBAT_BONUS:
				do.view_name = "铁护腕"
				do.unit_category = UnitCategoryTable.Enum.LAHORE_NIHANG
				do.required_promotion = [Enum.MOVEMENT_BONUS, Enum.NO_WOUNDED_PENALTY] as Array[Enum]
			Enum.MOVEMENT_BONUS:
				do.view_name = "铁头战靴"
				do.unit_category = UnitCategoryTable.Enum.LAHORE_NIHANG
				do.required_promotion = [Enum.FLANKED_BONUS, Enum.NO_WOUNDED_PENALTY] as Array[Enum]
			Enum.FLANKED_BONUS:
				do.view_name = "弯剑"
				do.unit_category = UnitCategoryTable.Enum.LAHORE_NIHANG
			Enum.ESCORT_MOBILITY:
				do.view_name = "护卫队机动性"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.required_promotion = [Enum.SPIKING_THE_GUNS, Enum.PURSUIT] as Array[Enum]
			Enum.SPIKING_THE_GUNS:
				do.view_name = "火药失效"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.required_promotion = [Enum.DEPREDATION, Enum.DOUBLE_ENVELOPMENT] as Array[Enum]
			Enum.DOUBLE_ENVELOPMENT:
				do.view_name = "两翼包围"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.required_promotion = [Enum.COURSERS] as Array[Enum]
			Enum.DEPREDATION:
				do.view_name = "掠夺"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.required_promotion = [Enum.CAPARISON] as Array[Enum]
			Enum.CAPARISON:
				do.view_name = "马衣"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
			Enum.PURSUIT:
				do.view_name = "追击"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
				do.required_promotion = [Enum.DEPREDATION, Enum.DOUBLE_ENVELOPMENT] as Array[Enum]
			Enum.COURSERS:
				do.view_name = "追猎者"
				do.unit_category = UnitCategoryTable.Enum.LIGHT_CAVALRY
			Enum.GROUND_CREWS:
				do.view_name = "地勤人员"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.required_promotion = [Enum.INTERCEPTOR] as Array[Enum]
			Enum.DROP_TANKS:
				do.view_name = "副油箱"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.required_promotion = [Enum.GROUND_CREWS, Enum.TANK_BUSTER] as Array[Enum]
			Enum.DOGFIGHTING:
				do.view_name = "空中缠斗"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
			Enum.INTERCEPTOR:
				do.view_name = "拦截机"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.required_promotion = [Enum.DOGFIGHTING] as Array[Enum]
			Enum.STRAFE:
				do.view_name = "扫射"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.required_promotion = [Enum.COCKPIT_ARMOR] as Array[Enum]
			Enum.TANK_BUSTER:
				do.view_name = "坦克克星"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
				do.required_promotion = [Enum.STRAFE] as Array[Enum]
			Enum.COCKPIT_ARMOR:
				do.view_name = "座舱护甲"
				do.unit_category = UnitCategoryTable.Enum.AIR_FIGHTER
			Enum.DANCING_CRANE:
				do.view_name = "白鹤拳"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.required_promotion = [Enum.EXPLODING_PALMS, Enum.DISCIPLES] as Array[Enum]
			Enum.EXPLODING_PALMS:
				do.view_name = "穿心掌"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.required_promotion = [Enum.SHADOW_STRIKE, Enum.TWILIGHT_VEIL] as Array[Enum]
			Enum.DISCIPLES:
				do.view_name = "弟子"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.required_promotion = [Enum.SHADOW_STRIKE, Enum.TWILIGHT_VEIL] as Array[Enum]
			Enum.SWEEPING_WIND:
				do.view_name = "凤舞拳"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.required_promotion = [Enum.EXPLODING_PALMS, Enum.DISCIPLES] as Array[Enum]
			Enum.TWILIGHT_VEIL:
				do.view_name = "迷魂幕"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
			Enum.COBRA_STRIKE:
				do.view_name = "蛇形拳"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
				do.required_promotion = [Enum.SWEEPING_WIND, Enum.DANCING_CRANE] as Array[Enum]
			Enum.SHADOW_STRIKE:
				do.view_name = "无影拳"
				do.unit_category = UnitCategoryTable.Enum.WARRIOR_MONK
			Enum.ARROW_STORM:
				do.view_name = "风暴之箭"
				do.unit_category = UnitCategoryTable.Enum.RANGE
				do.required_promotion = [Enum.VOLLEY] as Array[Enum]
			Enum.EMPLACEMENT:
				do.view_name = "炮台"
				do.unit_category = UnitCategoryTable.Enum.RANGE
				do.required_promotion = [Enum.INCENDIARIES, Enum.ARROW_STORM] as Array[Enum]
			Enum.VOLLEY:
				do.view_name = "齐射"
				do.unit_category = UnitCategoryTable.Enum.RANGE
			Enum.INCENDIARIES:
				do.view_name = "燃烧弹"
				do.unit_category = UnitCategoryTable.Enum.RANGE
				do.required_promotion = [Enum.GARRISON] as Array[Enum]
			Enum.EXPERT_MARKSMAN:
				do.view_name = "神枪手"
				do.unit_category = UnitCategoryTable.Enum.RANGE
				do.required_promotion = [Enum.SUPPRESSION, Enum.EMPLACEMENT] as Array[Enum]
			Enum.SUPPRESSION:
				do.view_name = "压制"
				do.unit_category = UnitCategoryTable.Enum.RANGE
				do.required_promotion = [Enum.INCENDIARIES, Enum.ARROW_STORM] as Array[Enum]
			Enum.GARRISON:
				do.view_name = "驻军"
				do.unit_category = UnitCategoryTable.Enum.RANGE
			Enum.ALPINE:
				do.view_name = "高山"
				do.unit_category = UnitCategoryTable.Enum.RECON
			Enum.AMBUSH:
				do.view_name = "埋伏"
				do.unit_category = UnitCategoryTable.Enum.RECON
				do.required_promotion = [Enum.GUERRILLA] as Array[Enum]
			Enum.SENTRY:
				do.view_name = "哨兵"
				do.unit_category = UnitCategoryTable.Enum.RECON
				do.required_promotion = [Enum.RANGER, Enum.ALPINE] as Array[Enum]
			Enum.SPYGLASS:
				do.view_name = "望远镜"
				do.unit_category = UnitCategoryTable.Enum.RECON
				do.required_promotion = [Enum.SENTRY] as Array[Enum]
			Enum.CAMOUFLAGE:
				do.view_name = "伪装"
				do.unit_category = UnitCategoryTable.Enum.RECON
				do.required_promotion = [Enum.SPYGLASS, Enum.AMBUSH] as Array[Enum]
			Enum.GUERRILLA:
				do.view_name = "游击队"
				do.unit_category = UnitCategoryTable.Enum.RECON
				do.required_promotion = [Enum.RANGER, Enum.ALPINE] as Array[Enum]
			Enum.RANGER:
				do.view_name = "游骑兵"
				do.unit_category = UnitCategoryTable.Enum.RECON
			Enum.CHARGE:
				do.view_name = "冲锋"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
			Enum.ARMOR_PIERCING:
				do.view_name = "穿透护甲"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.required_promotion = [Enum.MARAUDING] as Array[Enum]
			Enum.REACTIVE_ARMOR:
				do.view_name = "反应装甲"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.required_promotion = [Enum.ROUT] as Array[Enum]
			Enum.ROUT:
				do.view_name = "击溃"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.required_promotion = [Enum.BARDING, Enum.MARAUDING] as Array[Enum]
			Enum.MARAUDING:
				do.view_name = "抢劫"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.required_promotion = [Enum.CHARGE, Enum.ROUT] as Array[Enum]
			Enum.BREAKTHROUGH:
				do.view_name = "突破"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
				do.required_promotion = [Enum.ARMOR_PIERCING, Enum.REACTIVE_ARMOR] as Array[Enum]
			Enum.BARDING:
				do.view_name = "战马铠甲"
				do.unit_category = UnitCategoryTable.Enum.HEAVY_CAVALRY
			Enum.DEBATER:
				do.view_name = "辩论者"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.PILGRIM:
				do.view_name = "朝圣者"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.TRANSLATOR:
				do.view_name = "翻译员"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.CHAPLAIN:
				do.view_name = "牧师"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.PROSELYTIZER:
				do.view_name = "劝导者"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.INDULGENCE_VENDOR:
				do.view_name = "赎罪券小贩"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.MARTYR:
				do.view_name = "殉道者"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.ORATOR:
				do.view_name = "演说者"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
			Enum.HEATHEN_CONVERSION:
				do.view_name = "异教徒信仰转变"
				do.unit_category = UnitCategoryTable.Enum.RELIGIOUS
		super.init_insert(do)
