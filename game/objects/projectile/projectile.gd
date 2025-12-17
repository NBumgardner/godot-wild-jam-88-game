extends Area2D
class_name Projectile

const HOMING_SPEED = TAU / 10.0

@export var velocity: Vector2

var bounces: int = 0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var homing: Area2D = $Homing
@onready var homing_shape: CollisionShape2D = $Homing/HomingShape

func _ready() -> void:
	homing_shape.disabled = GameState.player_stats.projectile_homing_radius == 0.0
	homing_shape.shape.radius = GameState.player_stats.projectile_homing_radius
	

func _physics_process(delta: float) -> void:
	if homing.has_overlapping_bodies():
		var target := homing.get_overlapping_bodies()[0].global_position
		var angle := velocity.angle_to(target - global_position)
		velocity = velocity.rotated(sign(angle) * min(GameState.player_stats.projectile_homing_speed_mult * HOMING_SPEED * delta, abs(angle)))
	
	global_position += velocity * delta
	sprite_2d.frame_coords.x = floori((TAU / 4.0 - velocity.angle()) / TAU * 8.0)
	
	if not homing_shape.disabled:
		homing_shape.position = velocity.normalized() * homing_shape.shape.radius


func _on_body_entered(body: Node2D) -> void:
	assert(body is Enemy)
	body.hit()
	if bounces < GameState.player_stats.projectile_bounce:
		bounces += 1
		velocity = velocity.rotated(randf() * TAU)
	else:
		queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
