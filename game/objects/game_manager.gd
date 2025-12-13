extends Node
class_name GameManager

const VENT_HOLE = preload("uid://clxr0xys06nie")

@export var player: Player
@export var exit_vent: ExitVent
@export var num_vents: int = 10

var vents: Array[VentHole]

var remaining_vents: int:
	get(): return vents.size()

func _ready() -> void:
	(func ():
		for i in num_vents:
			var vent := VENT_HOLE.instantiate() as VentHole
			vent.position = Vector2(
				randf_range(-1500, 1500),
				randf_range(-1500, 1500))
			vent.tree_exited.connect(_on_vent_closed.bind(vent))
			get_parent().add_child(vent)
			vents.append(vent)
		remaining_vents = num_vents
	).call_deferred()

func _on_vent_closed(vent: VentHole) -> void:
	vents.erase(vent)
	if remaining_vents <= 0:
		exit_vent.active = true

func _on_exit_vent_player_touched() -> void:
	player.disable()


func _on_exit_vent_burst() -> void:
	player.launch()
	await get_tree().create_timer(3.0).timeout
	get_tree().reload_current_scene()
