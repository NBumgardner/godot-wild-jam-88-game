@tool
extends BTAction

@export var accept_radius: float = 0.0
@export var target_var: StringName = &"target"

func _generate_name() -> String:
	return "Moving to within %s pixels of $%s" % [accept_radius, target_var]

func _exit() -> void:
	agent.velocity = Vector2.ZERO

func _tick(delta: float) -> Status:
	var e := agent as Enemy
	var target_node: Node2D = blackboard.get_var(target_var)
	
	if not target_node:
		return FAILURE
	
	var travel := target_node.global_position - e.global_position
	
	if travel.length() <= accept_radius:
		return SUCCESS
	
	var target_velocity := travel.normalized() * e.get_max_move_speed()
	
	if e.velocity.is_zero_approx():
		e.velocity = target_velocity
	else:
		var target_angle := e.velocity.angle_to(target_velocity)
		e.velocity = e.velocity.rotated(sign(target_angle) * minf(abs(target_angle), e.get_turning_speed() * delta))
		e.velocity = e.velocity.normalized() * e.get_max_move_speed()
	
	e.move_and_slide()
	
	if e.global_position.distance_to(target_node.global_position) <= accept_radius:
		return SUCCESS
	
	for i in e.get_slide_collision_count():
		if e.get_slide_collision(i).get_collider() == target_node:
			return SUCCESS
	
	return RUNNING
