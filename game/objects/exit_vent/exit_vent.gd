extends Area2D
class_name ExitVent

signal player_touched()
signal burst()

var active: bool = false:
	set(v):
		active = v
		if audio_stream_player_2d:
			if active:
				audio_stream_player_2d.play()
			else:
				audio_stream_player_2d.stop()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _anim_burst() -> void:
	burst.emit()

func _on_body_entered(_body: Node2D) -> void:
	if not active:
		return
	
	EventBus.globalEnvironmentRiftBigEruption.emit()
	animation_player.play("explode")
	player_touched.emit()
