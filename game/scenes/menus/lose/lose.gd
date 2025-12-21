extends Control

func _ready() -> void:
	EventBus.globalCreditsEntered.emit()

func _on_button_back_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/menus/credits_menu/credits_menu.tscn")

func _on_button_back_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()
