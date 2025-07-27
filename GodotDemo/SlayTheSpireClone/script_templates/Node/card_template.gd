# meta-name: Card
# meta-description: What happens when a card is played.
extends Card

@export var optional_sound: AudioStream


func apply_effects(targets: Array[Node], modifiers: ModifierHandler) -> void:
	print("My awesome card has been played")
	print("Targets: %s" % targets)
