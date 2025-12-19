extends Area2D

const GRAVITY_Z = 2000.0

@export var velocity: Vector3

var position_z: float = 0.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _physics_process(delta: float) -> void:
	velocity.z -= GRAVITY_Z * delta
	position += Vector2(velocity.x, velocity.y) * delta
	position_z += velocity.z * delta
	
	sprite_2d.position.y = -position_z
	
	if position_z <= 0.0:
		set_physics_process(false)
		collision_shape_2d.disabled = false
		await get_tree().physics_frame
		print(get_overlapping_bodies())
		queue_free()
