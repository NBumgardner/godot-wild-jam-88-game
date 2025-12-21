extends Area2D
class_name BombProjectile

const GRAVITY_Z = 2000.0
const EXPLOSION_FX = preload("uid://bkhn510t2nwdo")

@export var velocity: Vector3
@export var bounces: int = 0

var position_z: float = 0.0

var homing_max_acceleration: float = 0.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var reticle: Sprite2D = $Reticle
@onready var homing_area: Area2D = %HomingArea
@onready var homing_area_shape: CollisionShape2D = %HomingArea/CollisionShape2D

func _ready() -> void:
	reticle.scale = Vector2.ONE * collision_shape_2d.shape.radius / 64.0
	reticle.global_position = compute_landing_position()
	if homing_max_acceleration != 0.0:
		homing_area_shape.disabled = false

func _process(delta: float) -> void:
	reticle.scale = Vector2.ONE * scale * collision_shape_2d.shape.radius / 64.0
	reticle.rotation += TAU * delta

func _physics_process(delta: float) -> void:
	velocity.z -= GRAVITY_Z * delta
	
	if homing_area.has_overlapping_bodies():
		var closest: Node2D
		var closest_dist: float = INF
		for bod in homing_area.get_overlapping_bodies():
			var d := bod.global_position.distance_to(homing_area.global_position)
			if d < closest_dist:
				closest = bod
				closest_dist = d
		apply_homing(delta, closest.global_position)
	
	position += Vector2(velocity.x, velocity.y) * delta
	position_z += velocity.z * delta
	
	sprite_2d.position.y = -position_z
	reticle.global_position = compute_landing_position()
	
	if position_z <= 0.0:
		set_physics_process(false)
		collision_shape_2d.disabled = false
		await get_tree().physics_frame
		for hittable in get_overlapping_bodies():
			hittable.hit()
		var fx = EXPLOSION_FX.instantiate()
		fx.position = position
		fx.emission_sphere_radius = collision_shape_2d.shape.radius
		get_parent().add_child(fx)
		if bounces > 0:
			position_z = 0.01
			bounces -= 1
			set_physics_process(true)
			collision_shape_2d.disabled = true
			velocity = velocity.rotated(Vector3(0, 0, 1), randf() * TAU)
			velocity.z = 0.5 * -velocity.z
		else:
			queue_free()

func compute_trajectory(to_target: Vector2, speed: float) -> void:
	var planar_vel := speed * to_target.normalized()
	var vel_z: float = 0.5 * GRAVITY_Z * to_target.length() / planar_vel.length()
	velocity = Vector3(planar_vel.x, planar_vel.y, vel_z)

func compute_landing_position() -> Vector2:
	var a := -0.5 * GRAVITY_Z
	var b := velocity.z
	var c := position_z
	var t := (-b - sqrt(b * b - 4.0 * a * c)) / (2.0 * a)
	return global_position + Vector2(velocity.x, velocity.y) * t

func apply_homing(delta: float, target: Vector2) -> void:
	var a := -0.5 * GRAVITY_Z
	var b := velocity.z
	var c := position_z
	var t := (-b - sqrt(b * b - 4.0 * a * c)) / (2.0 * a)
	var ideal_vel := (target - position) / t
	
	var vel := Vector2(velocity.x, velocity.y)
	vel = vel.move_toward(ideal_vel, delta * homing_max_acceleration)
	
	velocity.x = vel.x
	velocity.y = vel.y
