class_name Enemy
extends Area2D

const ARROW_OFFSET := 5

@export var stats: Stats : set = set_enemy_stats

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var arrow: Sprite2D = %Arrow
@onready var stats_ui: StatsUI = %StatsUI


func set_enemy_stats(value: Stats) -> void:
	stats = value.create_instance()
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	update_enemy()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	sprite_2d.texture = stats.art
	arrow.position = Vector2.RIGHT * (sprite_2d.get_rect().size.x / 2 + ARROW_OFFSET)
	update_stats()


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	stats.take_damage(damage)
	if stats.health <= 0:
		queue_free()
