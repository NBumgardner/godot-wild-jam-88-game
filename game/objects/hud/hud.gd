extends Control

@export var game_manager: GameManager

@onready var label: Label = $Label

func _ready() -> void:
	_update_text()

func _process(_delta: float) -> void:
	_update_text()

func _update_text() -> void:
	if game_manager.remaining_vents > 0:
		label.text = "Remaining vents: %s" % game_manager.remaining_vents
	else:
		label.text = "Get to the MEGA VENT!!!!!"
