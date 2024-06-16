extends CanvasLayer


@onready var throttle_value: RichTextLabel = $TopLeftGrid/ThrottleValue
@onready var speed_value: RichTextLabel = $TopLeftGrid/SpeedValue
@onready var height_value: RichTextLabel = $TopLeftGrid/HeightValue

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_first_node_in_group("PlaneController").throttle_changed.connect(_on_throttle_changed)
	get_tree().get_first_node_in_group("PlaneController").height_changed.connect(_on_height_changed)


func _on_throttle_changed(throttle: float):
	if throttle > 1:
		throttle_value.text = "[color=red]" + str(int(100 * throttle)) + " % 加力[/color]"
	else:
		throttle_value.text = str(int(100 * throttle)) + " %"
	speed_value.text = str(int(throttle * AirPlane.full_speed * 3.6)) + " km/h"


func _on_height_changed(height: float):
	height_value.text = str(int(height)) + " 米"
