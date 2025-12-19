extends Area2D
class_name VentHole

@export var girth: float = 1.0:
	set(v):
		girth = v
		if sprite:
			sprite.scale = remap(girth, 0.0, 1.0, 0.025, 0.25) * Vector2.ONE
		if is_inside_tree() and girth <= 0:
			EventBus.globalEnvironmentRiftAreaClosed.emit()
			queue_free()

@onready var guard_zone: GuardZone = $GuardZone
@onready var sprite: Sprite2D = $Sprite
