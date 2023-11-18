class_name GameCityInfoPanel
extends PanelContainer


signal production_button_toggled(button_pressed: bool)

var showing_city: City = null:
	set(city):
		showing_city = city
		if city == null:
			hide()
		else:
			show_info()

# 产出选择按钮
@onready var culture_check_box: CheckBox = $CityInfoVBox/YieldHBox/CultureCheckBox
@onready var food_check_box: CheckBox = $CityInfoVBox/YieldHBox/FoodCheckBox
@onready var product_check_box: CheckBox = $CityInfoVBox/YieldHBox/ProductCheckBox
@onready var science_check_box: CheckBox = $CityInfoVBox/YieldHBox/ScienceCheckBox
@onready var religion_check_box: CheckBox = $CityInfoVBox/YieldHBox/ReligionCheckBox
@onready var gold_check_box: CheckBox = $CityInfoVBox/YieldHBox/GoldCheckBox
# 城市名字相关
@onready var city_name_panel: PanelContainer = $CityInfoVBox/NamePanel
@onready var capital_texture_rect: TextureRect = $CityInfoVBox/NamePanel/NameHBox/CapitalTextureRect
@onready var city_name_label: Label = $CityInfoVBox/NamePanel/NameHBox/NameLabel
# 城市所属文明图片
@onready var city_pic_panel: PanelContainer = $CityInfoVBox/DetailHBox/CityPicPanel
@onready var city_texture_rect: TextureRect = $CityInfoVBox/DetailHBox/CityPicPanel/CityTextureRect
# 城市生产相关
@onready var city_production_button: Button = $CityInfoVBox/ButtonHBox/ProductButton
@onready var city_product_texture_rect: TextureRect = $CityInfoVBox/DetailHBox/ProductTextureRect
@onready var city_producing_label: Label = $CityInfoVBox/DetailHBox/RightVBox/ProducingLabel
@onready var city_data_label: Label = $CityInfoVBox/DetailHBox/RightVBox/DataLabel
@onready var city_intro_label: Label = $CityInfoVBox/DetailHBox/RightVBox/IntroLabel
@onready var city_product_progress: ProgressBar = $CityInfoVBox/ProgressHBox/ProductBar
@onready var city_product_turn_label: Label = $CityInfoVBox/ProgressHBox/ProductBar/ProductTurnLabel


func _ready() -> void:
	city_product_progress.value = 0.0


func show_info() -> void:
	if showing_city == null:
		printerr("GameCityInfoPanel | show_info | weird, no showing city, but show")
		return
	
	# 刷新内容
	var city_do: CityDO = CityController.get_city_do(showing_city.id)
	city_name_label.text = city_do.name
	capital_texture_rect.visible = city_do.capital
	# 城市所属玩家颜色
	var player_do: PlayerDO = PlayerController.get_player_do(city_do.player_id)
	city_texture_rect.modulate = player_do.second_color
	city_name_label.add_theme_color_override("font_color", player_do.second_color)
	city_name_panel.get("theme_override_styles/panel").set("bg_color", player_do.main_color)
	city_pic_panel.get("theme_override_styles/panel").set("bg_color", player_do.main_color)
	# 产量显示
	var yield_dto: YieldDTO = CityController.get_city_yield(showing_city.id)
	update_city_yield_culture(yield_dto.culture)
	update_city_yield_food(yield_dto.food)
	update_city_yield_product(yield_dto.production)
	update_city_yield_science(yield_dto.science)
	update_city_yield_religion(yield_dto.religion)
	update_city_yield_gold(yield_dto.gold)
	# 生产单位显示
	handle_city_production_changed(showing_city.id)
	# 绑定信号，方便后续更新信息
	connect_showing_city_signals()
	# 展示出来
	show()


func yield_text(val: float) -> String:
	if val < 0:
		return "%.1f" % val
	if val == 0:
		return "0"
	else:
		return "+%.1f" % val


func connect_showing_city_signals() -> void:
	ViewSignalsEmitter.get_instance().city_production_changed.connect(handle_city_production_changed)


func set_product_button_pressed(button_pressed: bool) -> void:
	city_production_button.button_pressed = button_pressed


func handle_chosen_city_changed(city: City) -> void:
	showing_city = city


func handle_city_production_changed(id: int) -> void:
	if showing_city == null or id != showing_city.id:
		return
	var city_do: CityDO = CityController.get_city_do(id)
	if city_do.producing_type == -1:
		city_product_texture_rect.texture = null
		city_producing_label.text = "没有生产任何东西"
		city_data_label.text = ""
		city_intro_label.text = ""
		city_product_turn_label.text = "0 回合后完成"
	else:
		city_product_texture_rect.texture = UnitController.get_unit_pic_webp_256x256(city_do.producing_type)
		city_producing_label.text = UnitController.get_unit_name(city_do.producing_type)
		# TODO: 单位数据和简介
		city_data_label.text = "移动力：2"
		city_intro_label.text = "这是正在制造一个" + city_producing_label.text + "的简介"
		var yield_product = CityController.get_city_yield(id).production
		city_product_turn_label.text = str(ceili((80.0 - city_do.production_sum) / yield_product)) + " 回合后完成"
	# 选择新生产单位时强制刷新进度条
	# TODO: 先全部按开拓者的生产计算
	city_product_progress.value = city_do.production_sum * 100.0 / 80.0


func update_city_yield_culture(val: float) -> void:
	culture_check_box.text = yield_text(val)


func update_city_yield_food(val: float) -> void:
	food_check_box.text = yield_text(val)


func update_city_yield_product(val: float) -> void:
	product_check_box.text = yield_text(val)


func update_city_yield_science(val: float) -> void:
	science_check_box.text = yield_text(val)


func update_city_yield_religion(val: float) -> void:
	religion_check_box.text = yield_text(val)


func update_city_yield_gold(val: float) -> void:
	gold_check_box.text = yield_text(val)


## 生产单位的按钮的状态发生改变
func _on_product_button_toggled(button_pressed: bool) -> void:
	production_button_toggled.emit(button_pressed)
