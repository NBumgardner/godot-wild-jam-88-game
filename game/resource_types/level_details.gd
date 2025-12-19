extends Resource
class_name LevelDetails

@export var num_vents: int = 2

@export_range(0.0, 100.0) var chase_max_enemies: int = 10
@export var chase_spawn_rate: float = 1.0
@export var chase_enemies: Array[EnemySpawn]

@export_range(0.0, 100.0) var defender_num_per_vent: int = 1
@export var defender_enemies: Array[EnemySpawn]
