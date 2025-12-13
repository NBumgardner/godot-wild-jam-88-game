extends Control

@export var game_manager: GameManager

@onready var label: Label = $%LabelGoalReminder

func _ready() -> void:
	_update_text()

func _process(_delta: float) -> void:
	_update_text()

func _update_text() -> void:
	if game_manager and game_manager.remaining_vents > 0:
		label.text = "Remaining vents: %s" % game_manager.remaining_vents
	else:
		label.text = "Get to the MEGA VENT!!!!!"

#region button pressed
func _on_button_quit_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/start_menu/start_menu.tscn")
#endregion button pressed
