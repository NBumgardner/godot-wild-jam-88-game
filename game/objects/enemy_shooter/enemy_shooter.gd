extends Enemy

const SPEED = 100.0
const TURN_SPEED = 3.0
const SHOOTER_PROJECTILE = preload("uid://o3mnf6g52ar0")
const PROJECTILE_SPEED = 300.0

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var bt_player: BTPlayer = $BTPlayer

func _ready() -> void:
	bt_player.blackboard.set_var("guard_zone", guard_zone)
	
	if not guard_zone:
		bt_player.blackboard.set_var("target", player)
	
	guard_zone.player_aggrod.connect(_on_player_aggrod)

func _physics_process(_delta: float) -> void:
	if velocity.x > 0:
		sprite_2d.flip_h = true
	elif velocity.x < 0:
		sprite_2d.flip_h = false

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
	print("ASDF!")
	var target: Node2D = bt_player.blackboard.get_var("target")
	print(target)
	if not target:
		return
	var projectile = SHOOTER_PROJECTILE.instantiate()
	var to_target := target.global_position - global_position
	var planar_vel := PROJECTILE_SPEED * to_target.normalized()
	var vel_z: float = 0.5 * projectile.GRAVITY_Z * to_target.length() / planar_vel.length()
	projectile.position = position
	projectile.velocity = Vector3(planar_vel.x, planar_vel.y, vel_z)
	
	get_parent().add_child(projectile)

func _on_player_aggrod(target: Player) -> void:
	bt_player.blackboard.set_var("target", target)
