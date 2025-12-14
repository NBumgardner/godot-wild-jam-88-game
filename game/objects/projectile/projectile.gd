extends Area2D
class_name Projectile

@export var velocity: Vector2

@onready var sprite_2d: Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	sprite_2d.rotation = velocity.angle()


func _on_body_entered(body: Node2D) -> void:
	assert(body is Enemy)
	body.hit()
	queue_free()


func _on_life_timer_timeout() -> void:
	queue_free()
