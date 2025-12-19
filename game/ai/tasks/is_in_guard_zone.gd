@tool
extends BTCondition

@export var guard_zone_var: StringName = &"guard_zone"
@export var guardless_mode: Status = Status.SUCCESS

func _generate_name() -> String:
	return "Check if within guard radius of $%s" % [guard_zone_var]

func _tick(_delta: float) -> Status:
	var gz: GuardZone = blackboard.get_var(guard_zone_var)
	if not gz:
		return guardless_mode
	var d: float = agent.global_position.distance_to(gz.global_position)
	if d <= gz.chase_radius:
		return SUCCESS
	return FAILURE
