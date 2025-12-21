extends Node2D

signal _dialog_next()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_target: Marker2D = $CameraTarget
@onready var fade: ColorRect = $HUDLayer/Fade
@onready var dialog: Control = %Dialog
@onready var dialog_text: RichTextLabel = %DialogText


func _ready() -> void:
	if GameState.current_level == 1:
		EventBus.globalLevel1Started.emit()
	else:
		EventBus.globalLevelNStarted.emit()
	
	match GameState.current_level:
		1:
			intro_cutscene()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			if event.keycode == KEY_KP_7:
				_on_exit_vent_player_touched.call_deferred()
			elif event.keycode == KEY_KP_8:
				GameState.player_stats.add_upgrade(PlayerStats.Upgrade.KEY_BOMB)
			elif event.keycode == KEY_KP_9:
				GameState.player_stats.add_upgrade(PlayerStats.Upgrade.KEY_VIRUS)
			elif event.keycode == KEY_KP_1:
				GameState.player_stats.add_upgrade(PlayerStats.Upgrade.PROJECTILE_SIZE_UP)
			elif event.keycode == KEY_KP_2:
				GameState.player_stats.add_upgrade(PlayerStats.Upgrade.PROJECTILE_HOMING)
			elif event.keycode == KEY_KP_3:
				GameState.player_stats.add_upgrade(PlayerStats.Upgrade.MAX_HP)

func intro_cutscene() -> void:
	get_tree().paused = true
	await show_dialog("It appears that we have crash landed on the planet Boreas VII.")
	await show_dialog("The area we are in is much too cold for our species, and the native Krytlians are known to be hostile.")
	await show_dialog("We have identified a hot caldera where we can survive, but there are unpassable chasms in the way.")
	await show_dialog("Fortunately, there are thermal vents that we can use to propel us closer to the caldera.")
	await show_dialog("Approach smaller vents to close them and build up enough pressure in the main vent to propel us forward. Good luck!")
	dialog.visible = false
	get_tree().paused = false

func show_dialog(s: String) -> void:
	dialog.visible = true
	dialog_text.text = s
	dialog_text.create_tween().tween_property(dialog_text, "visible_ratio", 1.0, 1.0).from(0.0)
	await _dialog_next

func _on_player_dead() -> void:
	EventBus.globalLevelFailed.emit()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/menus/lose/lose.tscn")

func _on_exit_vent_player_touched() -> void:
	EventBus.globalLevelSuccess.emit()
	var duration := 1.0
	var tween := create_tween()
	tween.tween_property(camera_target, "position:y", camera_target.position.y - 800.0, duration) \
		.set_trans(Tween.TRANS_QUAD) \
		.set_ease(Tween.EASE_IN)
	fade.visible = true
	tween.parallel().tween_property(fade, "modulate:a", 1.0, duration)
	tween.tween_interval(0.2)
	await tween.finished
	GameState.goto_next_level()


func _on_dialog_next_button_pressed() -> void:
	_dialog_next.emit()
