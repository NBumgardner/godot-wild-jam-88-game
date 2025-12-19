extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera_target: Marker2D = $CameraTarget
@onready var fade: ColorRect = $HUDLayer/Fade


func _ready() -> void:
	if GameState.current_level == 1:
		EventBus.globalLevel1Started.emit()
	else:
		EventBus.globalLevelNStarted.emit()

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.is_echo() and event.keycode == KEY_KP_7:
			_on_exit_vent_player_touched.call_deferred()

func _on_player_dead() -> void:
	EventBus.globalLevelFailed.emit()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/menus/start_menu/start_menu.tscn")

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
