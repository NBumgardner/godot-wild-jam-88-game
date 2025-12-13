extends Node
class_name GameManager

const VENT_HOLE = preload("uid://clxr0xys06nie")

@export var num_vents: int = 10

var remaining_vents: int

func _ready() -> void:
	(func ():
		for i in num_vents:
			var vent := VENT_HOLE.instantiate() as VentHole
			vent.position = Vector2(
				randf_range(-1500, 1500),
				randf_range(-1500, 1500))
			vent.tree_exited.connect(func ():
				remaining_vents -= 1)
			get_parent().add_child(vent)
		remaining_vents = num_vents
	).call_deferred()
