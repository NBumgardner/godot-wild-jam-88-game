extends Control

const ARROW_DIST = 120.0

@export var player: Player
@export var game_manager: GameManager

@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(_delta: float) -> void:
	var closest_point: Vector2 = Vector2.ZERO
	var closest_distance: float = INF
	
	var targets = game_manager.vents if game_manager.vents else [game_manager.exit_vent]
	
	for target in targets:
		var distance := player.global_position.distance_to(target.global_position)
		if distance < closest_distance:
			closest_point = target.global_position - player.global_position
			closest_distance = distance
	
	closest_point *= get_viewport().get_camera_2d().zoom * Vector2(0.5, 0.5)
	
	sprite_2d.position = size/2.0 + closest_point.limit_length(ARROW_DIST)
	sprite_2d.rotation = closest_point.angle()
	sprite_2d.scale = clampf((closest_point.length() / ARROW_DIST), 0.0, 1.0) * Vector2.ONE
