extends Node

const ENEMY = preload("uid://b464h76qb351y")

@export var player: Player
@export var max_enemies: int = 10
@export var spawn_cooldown: float = 1.0
@export var spawn_radius: float = 300.0

var enemies: Array[Enemy]

var _spawn_cooldown: float = 0.0

func _ready() -> void:
	_spawn_cooldown = spawn_cooldown

func _process(delta: float) -> void:
	_spawn_cooldown -= delta
	if _spawn_cooldown <= 0.0 and enemies.size() < max_enemies:
		_spawn_cooldown = spawn_cooldown
		_spawn_enemy()


func _spawn_enemy() -> void:
	var enemy := ENEMY.instantiate() as Enemy
	enemy.position = player.position + Vector2.from_angle(randf() * TAU) * spawn_radius
	enemy.player = player
	enemy.tree_exiting.connect(func ():
		enemies.erase(enemy))
	enemies.append(enemy)
	get_parent().add_child(enemy)
