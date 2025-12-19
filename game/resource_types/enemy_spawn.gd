extends Resource
class_name EnemySpawn

@export var enemy_scene: PackedScene = load("res://objects/enemy_walker/enemy_walker.tscn")
@export var spawn_chance: float = 1.0
