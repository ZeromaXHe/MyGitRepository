class_name ContextComponent
extends CenterContainer

@export var icon: Label
@export var context: Label
@export var default_icon: String


func _ready() -> void:
	MessageBus.interaction_focused.connect(update)
	MessageBus.interaction_unfocused.connect(reset)
	reset()


func reset() -> void:
	icon.text = ""
	context.text = ""


func update(my_text: String, icon_text: String = default_icon, override: bool = false) -> void:
	context.text = my_text
	if override:
		icon.text = icon_text
	else:
		icon.text = default_icon
