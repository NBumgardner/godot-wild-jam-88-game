extends Control

@export var game_manager: GameManager
@export var player: Player

@onready var label: Label = $%LabelGoalReminder
@onready var health_bar: Label = %HealthBar

func _ready() -> void:
	_update_text()

func _process(_delta: float) -> void:
	_update_text()

func _update_text() -> void:
	if game_manager and game_manager.remaining_vents > 0:
		label.text = "Remaining vents: %s" % game_manager.remaining_vents
	else:
		label.text = "Get to the MEGA VENT!!!!!"
	
	health_bar.text = "❤️".repeat(player.current_hp) + "❌".repeat(player.max_hp - player.current_hp)

#region SFX
func _on_button_quit_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()

func _on_button_quit_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/menus/start_menu/start_menu.tscn")
#endregion SFX
