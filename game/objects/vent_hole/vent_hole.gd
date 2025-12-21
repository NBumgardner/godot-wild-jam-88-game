extends Area2D
class_name VentHole

signal sealed()

@export var enabled := true:
	set(v):
		enabled = v
		queue_redraw()

@export var girth: float = 1.0:
	set(v):
		var b4 := 4 - floori(girth * 4.0)
		girth = v
		var after := 4 - floori(girth * 4.0)
		if is_inside_tree() and girth <= 0:
			EventBus.globalEnvironmentRiftAreaClosed.emit(self)
			sealed.emit()
			guard_zone.queue_free()
		elif b4 != after:
			EventBus.globalRiftSealProgress.emit(clampi(after - 1, 0, 3))

@onready var guard_zone: GuardZone = $GuardZone
@onready var sprite: Sprite2D = $Sprite
@onready var sprite_flare_1: Sprite2D = $SpriteFlare1
@onready var sprite_flare_2: Sprite2D = $SpriteFlare2
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _draw() -> void:
	if enabled:
		draw_circle(Vector2.ZERO, collision_shape.shape.radius, Color.DARK_MAGENTA, false)

func fade_effects() -> void:
	var tween := create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD).set_parallel()
	tween.tween_property(sprite_flare_1, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	tween.tween_property(sprite_flare_2, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.2)
	sprite_flare_1.visible = false
	sprite_flare_2.visible = false
	particles.emitting = false

func seal_animation() -> void:
	animation_player.play("seal")
	animation_player.advance(0.0)
