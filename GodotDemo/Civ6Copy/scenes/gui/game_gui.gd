class_name GameGUI
extends CanvasLayer


@onready var wiki_panel: WikiPanel = $WikiPanelContainer

func _ready() -> void:
	wiki_panel.visible = false


func _on_civ_pedia_button_pressed() -> void:
	wiki_panel.visible = true
