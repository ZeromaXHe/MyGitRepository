class_name PlayerHandler
extends Node

const HAND_DRAW_INTERNAL := 0.25
const HAND_DISCARD_INTERNAL := 0.25

@export var hand: Hand

var character: CharacterStats


func _ready() -> void:
	Events.card_played.connect(_on_card_played)


func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	start_turn()


func start_turn() -> void:
	character.block = 0
	character.reset_mana()
	draw_cards(character.cards_per_turn)


func end_turn() -> void:
	hand.disable_hand()
	discard_cards()


func draw_card() -> void:
	reshuffle_deck_from_discard()
	hand.add_card(character.draw_pile.draw_card())
	reshuffle_deck_from_discard()


func draw_cards(amount: int) -> void:
	var tween := create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERNAL)
	tween.finished.connect(func(): Events.player_hand_drawn.emit())


func discard_cards() -> void:
	if hand.get_child_count() == 0:
		Events.player_hand_discarded.emit()
		return
	var tween := create_tween()
	for card_ui in hand.get_children():
		# 匿名函数（lambda）和 Callable 等效：也就是说下面等同于
		# tween.tween_callback(character.discard.add_card.bind(card_ui.card))
		# tween.tween_callback(hand.discard_card.bind(card_ui))
		tween.tween_callback(func(): character.discard.add_card(card_ui.card))
		tween.tween_callback(func(): hand.discard_card(card_ui))
		tween.tween_interval(HAND_DISCARD_INTERNAL)
	tween.finished.connect(func(): Events.player_hand_discarded.emit())


func reshuffle_deck_from_discard() -> void:
	if not character.draw_pile.empty():
		return
	while not character.discard.empty():
		character.draw_pile.add_card(character.discard.draw_card())
	character.draw_pile.shuffle()


func _on_card_played(card: Card) -> void:
	character.discard.add_card(card)
