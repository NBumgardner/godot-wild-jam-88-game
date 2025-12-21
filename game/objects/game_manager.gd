extends Node
class_name GameManager

signal vent_opened(vent: VentHole)

const VENT_HOLE = preload("uid://clxr0xys06nie")

@export var player: Player
@export var exit_vent: ExitVent
@export var vent_parent: Node

var vents: Array[VentHole]

var remaining_vents: int:
	get(): return vents.size()

func _ready() -> void:
	await Defer.defer()
	
	for i in GameState.level_details.num_vents:
		var vent := VENT_HOLE.instantiate() as VentHole
		vent.position = Vector2(
			randf_range(-1500, 1500),
			randf_range(-1500, 1500))
		vent.sealed.connect(_on_vent_closed.bind(vent))
		vent_parent.add_child(vent)
		vents.append(vent)
		vent_opened.emit(vent)

func _on_vent_closed(vent: VentHole) -> void:
	vents.erase(vent)
	if remaining_vents <= 0:
		exit_vent.active = true

func _on_exit_vent_player_touched() -> void:
	player.disable()


func _on_exit_vent_burst() -> void:
	pass

func _on_player_dead() -> void:
	pass
