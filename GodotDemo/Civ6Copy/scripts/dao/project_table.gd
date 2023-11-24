class_name ProjectTable
extends MySimSQL.EnumTable


enum Enum {
	OPERATION_IVY, # 常春藤行动
	LAUNCH_EARTH_SATELLITE, # 发射地球卫星
	ENHANCE_DISTRICT_HARBOR, # 港口运输
	ENHANCE_DISTRICT_INDUSTRIAL_ZONE, # 工业区物流
	COURT_FESTIVAL, # 宫廷盛会
	LAUNCH_MARS_REACTOR, # 火星殖民地反应堆
	LAUNCH_MARS_HYDROPONICS, # 火星殖民地溶液栽培
	LAUNCH_MARS_HABITATION, # 火星殖民地住所
	BUILD_NUCLEAR_DEVICE, # 建造核装置
	BUILD_THERMONUCLEAR_DEVICE, # 建造热核装置
	ENHANCE_DISTRICT_THEATER, # 剧院广场庆祝活动
	ENHANCE_DISTRICT_ENCAMPMENT, # 军营训练
	CARNIVAL, # 狂欢节
	LIJIA_GOLD, # 里甲（金币）
	LIJIA_FOOD, # 里甲（食物）
	LIJIA_FAITH, # 里甲（信仰值）
	MANHATTAN_PROJECT, # 曼哈顿计划
	LAUNCH_MOON_LANDING, # 启动登月计划
	ENHANCE_DISTRICT_COMMERCIAL_HUB, # 商业投资中心
	ENHANCE_DISTRICT_HOLY_SITE, # 圣地祷告者
	REPAIR_OUTER_DEFENSES, # 修复外围防线
	ENHANCE_DISTRICT_CAMPUS, # 学院研究补助金
}


func _init() -> void:
	super._init()
	elem_type = ProjectDO
	
	for k in Enum.keys():
		var do = ProjectDO.new()
		do.enum_name = k
		do.enum_val = Enum[k]
		match do.enum_val:
			Enum.OPERATION_IVY:
				do.view_name = "常春藤行动"
				do.required_tech = TechTable.Enum.NUCLEAR_FUSION
				do.required_project = Enum.MANHATTAN_PROJECT
			Enum.LAUNCH_EARTH_SATELLITE:
				do.view_name = "发射地球卫星"
				do.required_district = DistrictTable.Enum.SPACEPORT
				do.required_tech = TechTable.Enum.ROCKETRY
			Enum.ENHANCE_DISTRICT_HARBOR:
				do.view_name = "港口运输"
				do.required_district = DistrictTable.Enum.HARBOR
			Enum.ENHANCE_DISTRICT_INDUSTRIAL_ZONE:
				do.view_name = "工业区物流"
				do.required_district = DistrictTable.Enum.INDUSTRIAL_ZONE
			Enum.COURT_FESTIVAL:
				do.view_name = "宫廷盛会"
				do.spec_leader = LeaderTable.Enum.CATHERINE_DE_MERCI_ALT
				do.required_district = DistrictTable.Enum.THEATER
			Enum.LAUNCH_MARS_REACTOR:
				do.view_name = "火星殖民地反应堆"
				do.required_district = DistrictTable.Enum.SPACEPORT
				do.required_tech = TechTable.Enum.NUCLEAR_FUSION
				do.required_project = Enum.LAUNCH_MOON_LANDING
			Enum.LAUNCH_MARS_HYDROPONICS:
				do.view_name = "火星殖民地溶液栽培"
				do.required_district = DistrictTable.Enum.SPACEPORT
				do.required_tech = TechTable.Enum.NANOTECHNOLOGY
				do.required_project = Enum.LAUNCH_MOON_LANDING
			Enum.LAUNCH_MARS_HABITATION:
				do.view_name = "火星殖民地住所"
				do.required_district = DistrictTable.Enum.SPACEPORT
				do.required_tech = TechTable.Enum.ROBOTICS
				do.required_project = Enum.LAUNCH_MOON_LANDING
			Enum.BUILD_NUCLEAR_DEVICE:
				do.view_name = "建造核装置"
				do.required_resource = ResourceTable.Enum.URANIUM
				do.required_tech = TechTable.Enum.NUCLEAR_FISSION
				do.required_project = Enum.MANHATTAN_PROJECT
			Enum.BUILD_THERMONUCLEAR_DEVICE:
				do.view_name = "建造热核装置"
				do.required_resource = ResourceTable.Enum.URANIUM
				do.required_tech = TechTable.Enum.NUCLEAR_FUSION
				do.required_project = Enum.OPERATION_IVY
			Enum.ENHANCE_DISTRICT_THEATER:
				do.view_name = "剧院广场庆祝活动"
				do.required_district = DistrictTable.Enum.THEATER
			Enum.ENHANCE_DISTRICT_ENCAMPMENT:
				do.view_name = "军营训练"
				do.required_district = DistrictTable.Enum.ENCAMPMENT
			Enum.CARNIVAL:
				do.view_name = "狂欢节"
				do.spec_civ = CivTable.Enum.BRAZIL
				do.required_district = DistrictTable.Enum.STREET_CARNIVAL
			Enum.LIJIA_GOLD:
				do.view_name = "里甲（金币）"
				do.spec_leader = LeaderTable.Enum.YONGLE
			Enum.LIJIA_FOOD:
				do.view_name = "里甲（食物）"
				do.spec_leader = LeaderTable.Enum.YONGLE
			Enum.LIJIA_FAITH:
				do.view_name = "里甲（信仰值）"
				do.spec_leader = LeaderTable.Enum.YONGLE
			Enum.MANHATTAN_PROJECT:
				do.view_name = "曼哈顿计划"
				do.required_tech = TechTable.Enum.NUCLEAR_FISSION
			Enum.LAUNCH_MOON_LANDING:
				do.view_name = "启动登月计划"
				do.required_district = DistrictTable.Enum.SPACEPORT
				do.required_tech = TechTable.Enum.SATELLITES
				do.required_project = Enum.LAUNCH_EARTH_SATELLITE
			Enum.ENHANCE_DISTRICT_COMMERCIAL_HUB:
				do.view_name = "商业投资中心"
				do.required_district = DistrictTable.Enum.COMMERCIAL_HUB
			Enum.ENHANCE_DISTRICT_HOLY_SITE:
				do.view_name = "圣地祷告者"
				do.required_district = DistrictTable.Enum.HOLY_SITE
			Enum.REPAIR_OUTER_DEFENSES:
				do.view_name = "修复外围防线"
			Enum.ENHANCE_DISTRICT_CAMPUS:
				do.view_name = "学院研究补助金"
				do.required_district = DistrictTable.Enum.CAMPUS
		super.init_insert(do)

