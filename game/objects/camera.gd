extends Camera2D

@export var follow_node: Node2D

func _process(_delta: float) -> void:
	if follow_node:
		global_position = follow_node.global_position
