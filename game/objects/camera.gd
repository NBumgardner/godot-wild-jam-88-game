extends Camera2D

@export var follow_node: Node2D

@export var velocity_parent: CharacterBody2D
@export var spring_constant: float = 100.0
@export var spring_damping_ratio: float = 1.0

var velocity: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	var spring_damping := spring_damping_ratio * 2.0 * sqrt(spring_constant)
	
	if follow_node:
		var d := follow_node.global_position - global_position
		velocity += delta * (spring_constant * d - spring_damping * velocity)
	else:
		velocity += delta * (-spring_damping * velocity)
	
	if velocity_parent:
		global_position += (velocity_parent.get_real_velocity() + velocity) * delta
	else:
		global_position += velocity * delta
