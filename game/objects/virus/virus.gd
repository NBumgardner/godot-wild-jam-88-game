extends Node2D

var bounces: int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	if bounces == 0:
		sprite_2d.modulate = Color.WHITE

func _on_move_timer_timeout() -> void:
	position = Vector2(0, -16) + Vector2(0.5, 1) * Vector2.from_angle(randf() * TAU) * sqrt(randf()) * 32.0
	sprite_2d.frame_coords.x = randi_range(0, 7)

func _on_life_timer_timeout() -> void:
	(get_parent() as Enemy).hit()

func _on_projectile_timer_timeout() -> void:
	var a := randf() * TAU
	for angle in 8:
		var dir := Vector2.from_angle(angle / 8.0 * TAU + a)
		var PROJECTILE = load("uid://do7s00elpsdcm")
		var projectile = PROJECTILE.instantiate()
		projectile.velocity = dir * Player.PROJECTILE_SPEED
		projectile.position = global_position
		projectile.scale *= GameState.player_stats.projectile_size_mult
		projectile.virus = bounces > 0
		projectile.bounces = bounces - 1
		projectile.get_node("LifeTimer").wait_time = GameState.player_stats.projectile_speed_mult
		get_parent().get_parent().add_child(projectile)
