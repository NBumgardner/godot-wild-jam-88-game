extends Control

@export var path_on_button_back_pressed: PackedScene

func _on_button_back_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file(path_on_button_back_pressed.resource_path)

func _on_button_back_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()
