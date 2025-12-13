extends Control

@export var game_manager: GameManager

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "Remaining vents: %s" % game_manager.remaining_vents

func _process(_delta: float) -> void:
	label.text = "Remaining vents: %s" % game_manager.remaining_vents
