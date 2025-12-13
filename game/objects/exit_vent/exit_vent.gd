extends Area2D
class_name ExitVent

signal player_touched()
signal burst()

var active: bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _anim_burst() -> void:
	burst.emit()

func _on_body_entered(_body: Node2D) -> void:
	if not active:
		return
	
	animation_player.play("explode")
	player_touched.emit()
