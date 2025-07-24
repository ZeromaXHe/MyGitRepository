class_name Run
extends Node

const BATTLE_SCENE = preload("res://scenes/battles/battle.tscn")
const BATTLE_REWARD_SCENE = preload("res://scenes/battle_rewards/battle_reward.tscn")
const CAMPFIRE_SCENE = preload("res://scenes/campfires/campfire.tscn")
const MAP_SCENE = preload("res://scenes/maps/map.tscn")
const SHOP_SCENE = preload("res://scenes/shops/shop.tscn")
const TREASURE_SCENE = preload("res://scenes/treasures/treasure.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = %CurrentView
@onready var deck_button: CardPileOpener = %DeckButton
@onready var deck_view: CardPileView = %DeckView

@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton

var character: CharacterStats


func _ready() -> void:
	if not run_startup:
		return
	match run_startup.type:
		RunStartup.Type.NEW_RUN:
			character = run_startup.picked_character.create_instance()
			_start_run()
		RunStartup.Type.CONTINUED_RUN:
			print("TODO: load previous Run")


func _start_run() -> void:
	_setup_event_connections()
	_setup_top_bar()
	print("TODO: procedurally generate map")


func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)


func _setup_event_connections() -> void:
	Events.battle_won.connect(func(): _change_view(BATTLE_REWARD_SCENE))
	Events.battle_reward_exited.connect(func(): _change_view(MAP_SCENE))
	Events.campfire_exited.connect(func(): _change_view(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(func(): _change_view(MAP_SCENE))
	Events.treasure_room_exited.connect(func(): _change_view(MAP_SCENE))
	
	battle_button.pressed.connect(func(): _change_view(BATTLE_SCENE))
	campfire_button.pressed.connect(func(): _change_view(CAMPFIRE_SCENE))
	map_button.pressed.connect(func(): _change_view(MAP_SCENE))
	rewards_button.pressed.connect(func(): _change_view(BATTLE_REWARD_SCENE))
	shop_button.pressed.connect(func(): _change_view(SHOP_SCENE))
	treasure_button.pressed.connect(func(): _change_view(TREASURE_SCENE))


func _setup_top_bar() -> void:
	deck_button.card_pile = character.deck
	deck_view.card_pile = character.deck
	deck_button.pressed.connect(func(): deck_view.show_current_view("Deck"))


func _on_map_exited() -> void:
	print("TODO: from the MAP, change view based on room type")
