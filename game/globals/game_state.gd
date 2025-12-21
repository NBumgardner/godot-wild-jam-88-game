extends Node

var player_stats: PlayerStats

var current_level: int = 0
var level_details: LevelDetails

func new_game() -> void:
	player_stats = PlayerStats.new()
	current_level = 0
	level_details = null
	goto_next_level()

func goto_next_level() -> void:
	current_level += 1
	level_details = null
	if ResourceLoader.exists("res://level_details/level_%s.tres" % current_level):
		level_details = load("res://level_details/level_%s.tres" % current_level)
	if not level_details:
		get_tree().change_scene_to_file("res://scenes/menus/win/win.tscn")
	elif current_level == 1:
		start_level()
	else:
		start_intermission()

func start_level() -> void:
	get_tree().change_scene_to_file("res://scenes/level1/level1.tscn")

func start_intermission() -> void:
	get_tree().change_scene_to_file("res://scenes/intermission/intermission.tscn")
