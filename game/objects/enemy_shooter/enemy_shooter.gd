extends Enemy

const SPEED = 100.0
const TURN_SPEED = 3.0
const SHOOTER_PROJECTILE = preload("uid://o3mnf6g52ar0")
const PROJECTILE_SPEED = 300.0
const ACCURACY_RADIUS = 96.0

@onready var sprite_2d: Sprite2D = $Sprite2D
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
	var target: Node2D = bt_player.blackboard.get_var("target")
	if not target:
		return
	var projectile = SHOOTER_PROJECTILE.instantiate() as BombProjectile
	var target_position := target.global_position + randf() * ACCURACY_RADIUS * Vector2.from_angle(randf() * TAU)
	var to_target := target_position - global_position
	projectile.position = position
	projectile.compute_trajectory(to_target, PROJECTILE_SPEED)
	
	get_parent().add_child(projectile)

func _on_player_aggrod(target: Player) -> void:
	bt_player.blackboard.set_var("target", target)
