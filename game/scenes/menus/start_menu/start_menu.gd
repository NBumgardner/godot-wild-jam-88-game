extends Control

@onready var buttonQuit: Button = $%ButtonQuit;

func _ready() -> void:
	if OS.get_name() == "Web":
		buttonQuit.visible = false

#region button pressed
func _on_button_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/credits_menu/credits_menu.tscn")

func _on_button_quit_pressed():
	get_tree().quit()

func _on_button_settings_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/settings_menu/settings_menu.tscn")

func _on_button_start_pressed():
	get_tree().change_scene_to_file("res://scenes/level1/level1.tscn")
#endegion button pressed
