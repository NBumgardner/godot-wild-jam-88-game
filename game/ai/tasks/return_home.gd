@tool
extends BTAction

@export var guard_zone_var: StringName = &"guard_zone"

func _generate_name() -> String:
	return "Returning to $%s" % [guard_zone_var]

func _exit() -> void:
	agent.velocity = Vector2.ZERO

func _tick(delta: float) -> Status:
	var e := agent as Enemy
	var guard_zone: GuardZone = blackboard.get_var(guard_zone_var)
	
	if not guard_zone:
		return FAILURE
	
	if e.global_position.distance_to(guard_zone.global_position) <= guard_zone.home_radius:
		return SUCCESS
	
	var travel := guard_zone.global_position - e.global_position
	
	var target_velocity := travel.normalized() * e.get_max_move_speed()
	
	if e.velocity.is_zero_approx():
		e.velocity = target_velocity
	else:
		var target_angle := e.velocity.angle_to(target_velocity)
		e.velocity = e.velocity.rotated(sign(target_angle) * minf(abs(target_angle), e.get_turning_speed() * delta))
		e.velocity = e.velocity.normalized() * e.get_max_move_speed()
	
	e.move_and_slide()
	
	if e.global_position.distance_to(guard_zone.global_position) <= guard_zone.home_radius:
		return SUCCESS
	
	return RUNNING
