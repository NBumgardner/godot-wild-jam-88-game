extends Marker2D
class_name CameraTarget

@export var follow_nodes: Array[Node2D]
@export var follow_node_weights: Array[float]
@export var follow_mouse: bool = true
@export var follow_mouse_weight: float = 1.0

func _ready() -> void:
	_update_position()

func _process(_delta: float) -> void:
	_update_position()

func _update_position() -> void:
	var total_weight: float = follow_mouse_weight if follow_mouse else 0.0
	var avg_position: Vector2 = Vector2.ZERO
	
	for w: float in follow_node_weights:
		total_weight += w
	
	for i in follow_nodes.size():
		avg_position += follow_nodes[i].global_position * follow_node_weights[i] / total_weight
	
	if follow_mouse:
		avg_position += get_global_mouse_position() * follow_mouse_weight / total_weight
	
	global_position = avg_position
