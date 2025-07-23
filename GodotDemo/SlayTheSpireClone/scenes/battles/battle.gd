extends Node2D

@export var char_stats: CharacterStats

@onready var battle_ui: BattleUI = %BattleUI
@onready var player_handler: PlayerHandler = %PlayerHandler
@onready var player: Player = %Player


func _ready() -> void:
	# Normally, we would do this on a 'Run'
	# level so we keep our health, gold and deck
	# between battles.
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	Events.player_turn_ended.connect(player_handler.end_turn)
	Events.player_hand_discarded.connect(player_handler.start_turn)
	
	start_battle(new_stats)


func start_battle(stats: CharacterStats) -> void:
	player_handler.start_battle(stats)
