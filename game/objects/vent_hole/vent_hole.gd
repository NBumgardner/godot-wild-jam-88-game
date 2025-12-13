extends Area2D
class_name VentHole

@export var girth: float = 1.0:
	set(v):
		girth = v
		scale = remap(girth, 0.0, 1.0, 0.1, 1.0) * Vector2.ONE
		if is_inside_tree() and girth <= 0:
			queue_free()
