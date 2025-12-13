extends CharacterBody2D


const SPEED = 600.0
const ACCEL = 10000.0
const VENT_CLOSE_SPEED = 0.5
const CAMERA_TARGET_DISTANCE = 150.0

@export var camera_target: Node2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var vent_detector: Area2D = $VentDetector
@onready var squirt_particles: GPUParticles2D = $SquirtParticles

func _ready() -> void:
	animation_tree["parameters/MovingBlendSpace/1/OneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		animation_tree["parameters/BlahOneShot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE
	
	squirt_particles.emitting = vent_detector.has_overlapping_areas()
	
	for vent: VentHole in vent_detector.get_overlapping_areas():
		vent.girth -= VENT_CLOSE_SPEED * delta
	

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = velocity.move_toward(input_dir * SPEED, ACCEL * delta)
	
	animation_tree["parameters/MovingBlendSpace/blend_position"] = velocity.length() / SPEED / 0.1
	
	if velocity.x > 0.0:
		sprite_2d.flip_h = true
	elif velocity.x < 0.0:
		sprite_2d.flip_h = false
	
	move_and_slide()
	
	if camera_target:
		camera_target.position = velocity.limit_length(CAMERA_TARGET_DISTANCE)
	
