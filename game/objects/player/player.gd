extends CharacterBody2D
class_name Player

signal dead()

const BASE_SPEED = 600.0
const ACCEL = 10000.0
const BASE_GOOP_PER_SECOND = 0.5
const CAMERA_TARGET_DISTANCE = 150.0

const PROJECTILE_SPEED = 700.0

const PROJECTILE = preload("uid://do7s00elpsdcm")

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

@export var camera_target: Node2D

var state: State = State.NORMAL: set = set_state

var current_hp: int

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
			var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
			velocity = velocity.move_toward(input_dir * BASE_SPEED * GameState.player_stats.speed_mult, ACCEL * delta)
			
			move_and_slide()
			
			handle_animation(input_dir)
			
			if camera_target:
				camera_target.position = position + velocity.limit_length(CAMERA_TARGET_DISTANCE)
		
		State.DISABLED:
			return
		State.LAUNCHED:
			position.y -= BASE_SPEED * 5.0 * delta
			return

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			var pos: Vector2 = get_viewport().canvas_transform.inverse() * event.position
			var dir := (pos - global_position).normalized()
			var projectile := PROJECTILE.instantiate() as Projectile
			projectile.velocity = dir * PROJECTILE_SPEED * GameState.player_stats.projectile_speed_mult
			projectile.position = global_position
			projectile.scale *= GameState.player_stats.projectile_size_mult
			get_parent().add_child(projectile)

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
