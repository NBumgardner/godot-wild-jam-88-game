extends CharacterBody2D
class_name Player

signal dead()

const BASE_SPEED = 300.0
const ACCEL = 10000.0
const BASE_GOOP_PER_SECOND = 0.5
const CAMERA_TARGET_DISTANCE = 150.0
const FIRE_DELAY = 1.0

const PROJECTILE_SPEED = 200.0
const PROJECTILE_INCIDENT_VELOCITY_RATIO = 0.5

const BOMB_HOMING_MAX_ACCEL = 500.0

const PROJECTILE = preload("uid://do7s00elpsdcm")
const PLAYER_BOMB_PROJECTILE = preload("uid://c2oqw1s8yox47")

enum State {
	## Normal gameplay state, player input enabled.
	NORMAL,
	## Input and physics disabled.
	DISABLED,
	## Input disabled, launching upwards.
	LAUNCHED,
	## Dead.
	DEAD,
}

var state: State = State.NORMAL: set = set_state

var current_hp: int

var fire_delay_time: float = 0.0

@onready var animation_tree: AnimationTree = $BlobTree
@onready var vent_detector: Area2D = $VentDetector
@onready var squirt_particles: CPUParticles2D = $SquirtParticles
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	current_hp = GameState.player_stats.max_hp

func _process(delta: float) -> void:
	match state:
		State.NORMAL:
			squirt_particles.emitting = vent_detector.has_overlapping_areas()
			
			for vent: VentHole in vent_detector.get_overlapping_areas():
				vent.girth -= BASE_GOOP_PER_SECOND * delta * GameState.player_stats.goop_mult

func _physics_process(delta: float) -> void:
	match state:
		State.NORMAL:
			fire_delay_time -= delta * GameState.player_stats.fire_rate_mult
			
			if fire_delay_time <= 0.0 and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var pos: Vector2 = get_viewport().canvas_transform.inverse() * get_viewport().get_mouse_position()
				fire_projectile(pos - global_position)
			
			var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			if input_dir and not velocity:
				EventBus.globalPlayerWalkStart.emit()
			
			velocity = velocity.move_toward(input_dir * BASE_SPEED * GameState.player_stats.speed_mult, ACCEL * delta)
			
			move_and_slide()
			
			handle_animation(input_dir)
		
		State.DISABLED:
			return
		State.LAUNCHED:
			position.y -= BASE_SPEED * 5.0 * delta
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if fire_delay_time <= 0.0 and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var pos: Vector2 = get_viewport().canvas_transform.inverse() * event.position
			fire_projectile(pos - global_position)

func fire_projectile(target: Vector2) -> void:
	EventBus.globalPlayerShoot.emit()
	
	var key_upgrade
	if not GameState.player_stats.key_upgrade.is_empty():
		key_upgrade = GameState.player_stats.key_upgrade[0]
	
	if key_upgrade == null or key_upgrade == PlayerStats.KeyUpgrade.VIRUS:
		var dir := target.normalized()
		var projectile := PROJECTILE.instantiate() as Projectile
		projectile.velocity = dir * PROJECTILE_SPEED * GameState.player_stats.projectile_speed_mult
		var incident_velocity := velocity.project(projectile.velocity) * PROJECTILE_INCIDENT_VELOCITY_RATIO
		if incident_velocity.dot(projectile.velocity) > 0.0:
			projectile.velocity += incident_velocity
		projectile.position = global_position
		projectile.scale *= GameState.player_stats.projectile_size_mult
		projectile.virus = key_upgrade == PlayerStats.KeyUpgrade.VIRUS
		get_parent().add_child(projectile)
		fire_delay_time = FIRE_DELAY
	elif key_upgrade == PlayerStats.KeyUpgrade.BOMB:
		var projectile := PLAYER_BOMB_PROJECTILE.instantiate() as BombProjectile
		projectile.position = global_position
		projectile.compute_trajectory(target, (target.length() / 128.0) * PROJECTILE_SPEED * GameState.player_stats.projectile_speed_mult)
		projectile.scale *= GameState.player_stats.projectile_size_mult
		projectile.bounces = GameState.player_stats.projectile_bounce
		if GameState.player_stats.projectile_homing_radius != 0.0:
			projectile.homing_max_acceleration = BOMB_HOMING_MAX_ACCEL * GameState.player_stats.projectile_homing_speed_mult
		get_parent().add_child(projectile)
		projectile.homing_area_shape.shape.radius += GameState.player_stats.projectile_homing_radius
		fire_delay_time = FIRE_DELAY

func set_state(s: State) -> void:
	state = s
	collision_shape_2d.set_deferred("disabled", state != State.NORMAL)
	vent_detector.monitoring = state == State.NORMAL

func disable() -> void:
	state = State.DISABLED

func launch() -> void:
	state = State.LAUNCHED

## Called when an enemy hits the player.
func hit() -> void:
	if state != State.NORMAL:
		return
	EventBus.globalPlayerHurt.emit()
	current_hp -= 1
	if current_hp <= 0:
		current_hp = 0
		state = State.DEAD
		dead.emit()

func handle_animation(input: Vector2) -> void:
	var moving = bool(sign(abs(input.length())))
	animation_tree.set("parameters/conditions/walk",moving)
	animation_tree.set("parameters/conditions/idle",!moving)
	if moving:
		animation_tree.set("parameters/WALK/blend_position",input.normalized())
