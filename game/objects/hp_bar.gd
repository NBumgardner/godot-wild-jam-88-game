extends Node2D

func _ready() -> void:
	get_parent().health_changed.connect(queue_redraw)

func _draw() -> void:
	var health: int = get_parent().health
	var starting_health: int = get_parent().starting_health
	
	if health < starting_health:
		draw_rect(Rect2(-16, -30, 32, 2), Color.RED)
		draw_rect(Rect2(-16, -30, 32, 2).grow_side(SIDE_RIGHT, -32.0 + 32.0 * health / starting_health), Color.GREEN)
