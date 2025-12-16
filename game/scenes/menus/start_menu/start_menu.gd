extends Control

@onready var buttonQuit: Button = $%ButtonQuit;

func _ready() -> void:
	if OS.get_name() == "Web":
		buttonQuit.visible = false
	
	GameState.reset()

#region button pressed
func _on_button_credits_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/menus/credits_menu/credits_menu.tscn")

func _on_button_quit_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().quit()

func _on_button_settings_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu/settings_menu.tscn")

func _on_button_start_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/gameplay/gameplay.tscn")
#endregion button pressed

#region button mouse entered
func _on_button_credits_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()

func _on_button_quit_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()

func _on_button_settings_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()

func _on_button_start_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()
#endregion button mouse entered
