@abstract
extends CharacterBody2D
class_name Enemy

signal health_changed()

const FX_ENEMY_DEATH = preload("uid://0aci2nmgds3l")

@export var player: Player:
	set(v):
		player = v
		_player_changed()

@export var guard_zone: GuardZone:
	set(v):
		guard_zone = v
		_guard_zone_changed()

@export var starting_health: int = 1

@onready var health: int = starting_health

func hit() -> void:
	health -= 1
	health_changed.emit()
	if health > 0:
		return
	
	EventBus.globalEnemyDestroyed.emit()
	queue_free()
	var fx = FX_ENEMY_DEATH.instantiate()
	fx.position = position
	get_parent().add_child(fx)

@abstract func get_max_move_speed() -> float
@abstract func get_turning_speed() -> float

@abstract func _player_changed() -> void
@abstract func _guard_zone_changed() -> void
