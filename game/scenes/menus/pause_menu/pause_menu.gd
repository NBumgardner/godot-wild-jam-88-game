extends PanelContainer

@export var title_scene: PackedScene

@onready var root_menu_container: PanelContainer = $CenterContainer/RootMenuContainer
@onready var settings_menu_container: PanelContainer = $CenterContainer/SettingsMenuContainer

@onready var resume_button: Button = $CenterContainer/RootMenuContainer/MarginContainer/VBoxContainer/ButtonResume
@onready var settings_button: Button = $CenterContainer/RootMenuContainer/MarginContainer/VBoxContainer/ButtonSettings
@onready var settings_back_button: Button = $CenterContainer/SettingsMenuContainer/MarginContainer/VBoxContainer/HBoxContainer/ButtonBack
@onready var quit_title_button: Button = $CenterContainer/RootMenuContainer/MarginContainer/VBoxContainer/ButtonQuitTitle
@onready var quit_os_button: Button = $CenterContainer/RootMenuContainer/MarginContainer/VBoxContainer/ButtonQuitOS

var game_paused_on_open := false

func _ready() -> void:
	resume_button.mouse_entered.connect(on_mouse_entered_button)
	settings_button.mouse_entered.connect(on_mouse_entered_button)
	settings_back_button.mouse_entered.connect(on_mouse_entered_button)
	quit_title_button.mouse_entered.connect(on_mouse_entered_button)
	quit_os_button.mouse_entered.connect(on_mouse_entered_button)
	
	resume_button.pressed.connect(on_resume_button_pressed)
	settings_button.pressed.connect(on_settings_button_pressed)
	settings_back_button.pressed.connect(on_settings_back_button_pressed)
	quit_title_button.pressed.connect(on_quit_to_title_button_pressed)
	quit_os_button.pressed.connect(on_quit_to_os_button_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if not visible:
			open_menu()
		elif settings_menu_container.visible:
			close_settings_menu()
		else:
			close_menu()

func open_menu() -> void:
	EventBus.globalUiElementSelected.emit()
	game_paused_on_open = get_tree().paused
	if not game_paused_on_open:
		get_tree().paused = true
	root_menu_container.show()
	settings_menu_container.hide()
	show()

func close_menu() -> void:
	hide()
	get_tree().paused = game_paused_on_open

func open_settings_menu() -> void:
	root_menu_container.hide()
	settings_menu_container.show()

func close_settings_menu() -> void:
	settings_menu_container.hide()
	root_menu_container.show()

func on_mouse_entered_button() -> void:
	EventBus.globalUiElementMouseEntered.emit()

func on_resume_button_pressed() -> void:
	EventBus.globalUiElementSelected.emit()
	close_menu()

func on_settings_button_pressed() -> void:
	EventBus.globalUiElementSelected.emit()
	open_settings_menu()

func on_settings_back_button_pressed() -> void:
	EventBus.globalUiElementSelected.emit()
	close_settings_menu()

func on_quit_to_title_button_pressed() -> void:
	EventBus.globalUiElementSelected.emit()
	get_tree().paused = false
	get_tree().change_scene_to_file(title_scene.resource_path)

func on_quit_to_os_button_pressed() -> void:
	get_tree().quit()
