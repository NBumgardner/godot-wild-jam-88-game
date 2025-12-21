extends "res://objects/bomb_projectile/bomb_projectile.gd"

func _process(delta: float) -> void:
	super._process(delta)
	var v := Vector2(velocity.x, velocity.y)
	sprite_2d.frame_coords.x = wrapi(roundi((TAU / 4.0 - v.angle()) / TAU * 8.0), 0, 8)
