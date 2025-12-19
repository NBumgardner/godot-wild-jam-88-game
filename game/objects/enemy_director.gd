extends Node

const ENEMY = preload("uid://b464h76qb351y")

@export var player: Player
@export var chase_spawn_radius: float = 400.0

var chasing_enemies: Array[Enemy]
var _chase_spawn_cooldown: float = 0.0

func _ready() -> void:
	_chase_spawn_cooldown = GameState.level_details.chase_spawn_rate

func _process(delta: float) -> void:
	_chase_spawn_cooldown -= delta
	if _chase_spawn_cooldown <= 0.0 and chasing_enemies.size() < GameState.level_details.chase_max_enemies:
		_chase_spawn_cooldown = GameState.level_details.chase_spawn_rate
		_spawn_chase_enemy()

func _spawn_chase_enemy() -> void:
	var enemy_spawn: EnemySpawn = RandomSampling.weighted_pick_random(
		GameState.level_details.chase_enemies,
		func (x: EnemySpawn): return x.spawn_chance)
	var enemy := enemy_spawn.enemy_scene.instantiate() as Enemy
	enemy.position = player.position + Vector2.from_angle(randf() * TAU) * chase_spawn_radius
	enemy.player = player
	enemy.tree_exiting.connect(func ():
		chasing_enemies.erase(enemy))
	chasing_enemies.append(enemy)
	get_parent().add_child(enemy)


func _on_game_manager_vent_opened(vent: VentHole) -> void:
	for i in GameState.level_details.defender_num_per_vent:
		var enemy_spawn: EnemySpawn = RandomSampling.weighted_pick_random(
			GameState.level_details.defender_enemies,
			func (x: EnemySpawn): return x.spawn_chance)
		var enemy := enemy_spawn.enemy_scene.instantiate() as Enemy
		print(vent.guard_zone)
		enemy.position = vent.guard_zone.global_position + sqrt(randf()) * vent.guard_zone.home_radius * Vector2.from_angle(randf() * TAU)
		enemy.player = player
		enemy.guard_zone = vent.guard_zone
		vent.guard_zone.tree_exiting.connect(enemy.set.bind("guard_zone", null))
		get_parent().add_child(enemy)
