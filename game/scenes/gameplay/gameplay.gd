extends Node2D

const LEVEL_1 = "uid://malxmp0cv835"
const INTERMISSION = "uid://bgj54nwjw8j5c"

var current_thing: Node

func _ready() -> void:
	goto_level()

func goto_level() -> void:
	if current_thing:
		current_thing.queue_free()
	current_thing = load(LEVEL_1).instantiate()
	add_child(current_thing)

func goto_intermission() -> void:
	if current_thing:
		current_thing.queue_free()
	current_thing = load(INTERMISSION).instantiate()
	add_child(current_thing)
