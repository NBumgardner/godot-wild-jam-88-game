extends Enemy

const SPEED = 90.0
const TURN_SPEED = 3.0

@onready var attack_hitbox: Area2D = $AttackHitbox
@onready var bt_player: BTPlayer = $BTPlayer
@onready var anim_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	bt_player.blackboard.set_var("guard_zone", guard_zone)
	
	if not guard_zone:
		bt_player.blackboard.set_var("target", player)
	else:
		guard_zone.player_aggrod.connect(_on_player_aggrod)

func _physics_process(_delta: float) -> void:
	anim_tree.set("parameters/BlendSpace/blend_position",remap(velocity.x, SPEED,-SPEED,1,-1))

func get_max_move_speed() -> float:
	return SPEED

func get_turning_speed() -> float:
	return TURN_SPEED

func _player_changed() -> void:
	if bt_player and not guard_zone:
		bt_player.blackboard.set_var("target", player)

func _guard_zone_changed() -> void:
	if bt_player:
		bt_player.blackboard.set_var("guard_zone", guard_zone)
		if not guard_zone:
			bt_player.blackboard.set_var("target", player)
		else:
			bt_player.blackboard.set_var("target", guard_zone.target)
			guard_zone.player_aggrod.connect(_on_player_aggrod)

func _attack_hit() -> void:
	for body in attack_hitbox.get_overlapping_bodies():
		assert(body is Player)
		body.hit()

func _on_player_aggrod(target: Player) -> void:
	bt_player.blackboard.set_var("target", target)
