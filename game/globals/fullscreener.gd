extends Node

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			match event.keycode:
				KEY_F11:
					if get_window().mode == Window.MODE_WINDOWED:
						get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
					else:
						get_window().mode = Window.MODE_WINDOWED
