class_name GameCityInfoPanel
extends PanelContainer


signal production_button_toggled(button_pressed: bool)

var chosen_city: City = null
var showing_city: City = null

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


func show_info() -> void:
	if chosen_city == null:
		printerr("GameCityInfoPanel | show_info | weird, no chosen city, but show")
		return
	if showing_city != chosen_city:
		showing_city = chosen_city
		# 刷新内容
		city_name_label.text = showing_city.city_name
		capital_texture_rect.visible = showing_city.capital
		# 城市所属玩家颜色
		city_texture_rect.modulate = showing_city.player.second_color
		city_name_label.add_theme_color_override("font_color", showing_city.player.second_color)
		city_name_panel.get("theme_override_styles/panel").set("bg_color", showing_city.player.main_color)
		city_pic_panel.get("theme_override_styles/panel").set("bg_color", showing_city.player.main_color)
		# 产量显示
		handle_city_yield_culture_changed(showing_city.yield_culture)
		handle_city_yield_food_changed(showing_city.yield_food)
		handle_city_yield_product_changed(showing_city.yield_product)
		handle_city_yield_science_changed(showing_city.yield_science)
		handle_city_yield_religion_changed(showing_city.yield_religion)
		handle_city_yield_gold_changed(showing_city.yield_gold)
		# 生产单位显示
		handle_city_producing_unit_type_changed(showing_city.producing_unit_type)
		handle_city_production_val_changed(showing_city.production_val)
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


func disconnect_showing_city_signals() -> void:
	if showing_city == null:
		return
	if showing_city.producing_unit_type_changed.is_connected(handle_city_producing_unit_type_changed):
		showing_city.producing_unit_type_changed.disconnect(handle_city_producing_unit_type_changed)
	if showing_city.production_val_changed.is_connected(handle_city_production_val_changed):
		showing_city.production_val_changed.disconnect(handle_city_production_val_changed)
	if showing_city.yield_culture_changed.is_connected(handle_city_yield_culture_changed):
		showing_city.yield_culture_changed.disconnect(handle_city_yield_culture_changed)
	if showing_city.yield_food_changed.is_connected(handle_city_yield_food_changed):
		showing_city.yield_food_changed.disconnect(handle_city_yield_food_changed)
	if showing_city.yield_product_changed.is_connected(handle_city_yield_product_changed):
		showing_city.yield_product_changed.disconnect(handle_city_yield_product_changed)
	if showing_city.yield_science_changed.is_connected(handle_city_yield_science_changed):
		showing_city.yield_science_changed.disconnect(handle_city_yield_science_changed)
	if showing_city.yield_religion_changed.is_connected(handle_city_yield_religion_changed):
		showing_city.yield_religion_changed.disconnect(handle_city_yield_religion_changed)
	if showing_city.yield_gold_changed.is_connected(handle_city_yield_gold_changed):
		showing_city.yield_gold_changed.disconnect(handle_city_yield_gold_changed)
		


func connect_showing_city_signals() -> void:
	if showing_city == null:
		return
	if not showing_city.producing_unit_type_changed.is_connected(handle_city_producing_unit_type_changed):
		showing_city.producing_unit_type_changed.connect(handle_city_producing_unit_type_changed)
	if not showing_city.production_val_changed.is_connected(handle_city_production_val_changed):
		showing_city.production_val_changed.connect(handle_city_production_val_changed)
	if not showing_city.yield_culture_changed.is_connected(handle_city_yield_culture_changed):
		showing_city.yield_culture_changed.connect(handle_city_yield_culture_changed)
	if not showing_city.yield_food_changed.is_connected(handle_city_yield_food_changed):
		showing_city.yield_food_changed.connect(handle_city_yield_food_changed)
	if not showing_city.yield_product_changed.is_connected(handle_city_yield_product_changed):
		showing_city.yield_product_changed.connect(handle_city_yield_product_changed)
	if not showing_city.yield_science_changed.is_connected(handle_city_yield_science_changed):
		showing_city.yield_science_changed.connect(handle_city_yield_science_changed)
	if not showing_city.yield_religion_changed.is_connected(handle_city_yield_religion_changed):
		showing_city.yield_religion_changed.connect(handle_city_yield_religion_changed)
	if not showing_city.yield_gold_changed.is_connected(handle_city_yield_gold_changed):
		showing_city.yield_gold_changed.connect(handle_city_yield_gold_changed)


func hide_info() -> void:
	disconnect_showing_city_signals()
	hide()


func set_product_button_pressed(button_pressed: bool) -> void:
	city_production_button.button_pressed = button_pressed


func handle_chosen_city_changed(city: City) -> void:
	chosen_city = city


func handle_city_producing_unit_type_changed(type: Unit.Type) -> void:
	if showing_city.producing_unit_type == -1:
		city_product_texture_rect.texture = null
		city_producing_label.text = "没有生产任何东西"
		city_data_label.text = ""
		city_intro_label.text = ""
	else:
		city_product_texture_rect.texture = Unit.get_unit_pic_webp_256x256(showing_city.producing_unit_type)
		city_producing_label.text = Unit.get_unit_name(showing_city.producing_unit_type)
		# TODO: 单位数据
		city_data_label.text = "移动力：2"
		city_intro_label.text = "这是正在制造一个" + city_producing_label.text + "的简介"


func handle_city_production_val_changed(val: float) -> void:
	# TODO: 先全部按开拓者的生产计算
	city_product_progress.value = val * 100.0 / 80.0


func handle_city_yield_culture_changed(val: float) -> void:
	culture_check_box.text = yield_text(val)


func handle_city_yield_food_changed(val: float) -> void:
	food_check_box.text = yield_text(val)


func handle_city_yield_product_changed(val: float) -> void:
	product_check_box.text = yield_text(val)


func handle_city_yield_science_changed(val: float) -> void:
	science_check_box.text = yield_text(val)


func handle_city_yield_religion_changed(val: float) -> void:
	religion_check_box.text = yield_text(val)


func handle_city_yield_gold_changed(val: float) -> void:
	gold_check_box.text = yield_text(val)


## 生产单位的按钮的状态发生改变
func _on_product_button_toggled(button_pressed: bool) -> void:
	production_button_toggled.emit(button_pressed)
