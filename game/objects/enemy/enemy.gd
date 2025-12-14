extends CharacterBody2D
class_name Enemy

const SPEED = 100.0

enum State {
	CHASE,
	ATTACK,
}

@export var player: Player
@export var attack_cooldown: float = 1.0

var _attack_cooldown: float

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var attack_hitbox: Area2D = $AttackHitbox

func _physics_process(delta: float) -> void:
	var dir := Vector2.ZERO
	
	if player and not animation_player.is_playing():
		dir = global_position.direction_to(player.global_position)
	
	velocity = dir * SPEED
	
	if velocity.x > 0:
		sprite_2d.flip_h = true
	elif velocity.x < 0:
		sprite_2d.flip_h = false
	
	move_and_slide()
	
	_attack_cooldown -= delta
	if _attack_cooldown <= 0:
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider() is Player:
				_attack_cooldown = attack_cooldown
				animation_player.play("attack")
				break

func _attack_hit() -> void:
	for body in attack_hitbox.get_overlapping_bodies():
		assert(body is Player)
		body.hit()

func hit() -> void:
	queue_free() # TODO: health
