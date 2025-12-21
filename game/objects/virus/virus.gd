extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

func _enter_tree() -> void:
	(get_parent() as Enemy).process_mode = Node.PROCESS_MODE_DISABLED

func _exit_tree() -> void:
	(get_parent() as Enemy).process_mode = Node.PROCESS_MODE_INHERIT

func _on_move_timer_timeout() -> void:
	position = Vector2(0, -16) + Vector2(0.5, 1) * Vector2.from_angle(randf() * TAU) * sqrt(randf()) * 32.0
	sprite_2d.frame_coords.x = randi_range(0, 7)

func _on_life_timer_timeout() -> void:
	(get_parent() as Enemy).hit()
	queue_free()

func _on_projectile_timer_timeout() -> void:
	var dir := Vector2.from_angle(randf() * TAU)
	var PROJECTILE = load("uid://do7s00elpsdcm")
	var projectile = PROJECTILE.instantiate()
	projectile.velocity = dir * Player.PROJECTILE_SPEED
	print(projectile.velocity)
	projectile.position = global_position
	projectile.scale *= 1.0
	projectile.virus = false
	get_parent().get_parent().add_child(projectile)
