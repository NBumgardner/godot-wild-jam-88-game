extends Node

var player_stats: PlayerStats

var current_level: int = 1

func reset() -> void:
	player_stats = PlayerStats.new()
	current_level = 1
