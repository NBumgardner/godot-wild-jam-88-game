extends Area2D
class_name GuardZone

signal player_aggrod(player: Player)

@export var home_radius: float = 120.0

var target: Player:
	set(v):
		target = v
		player_aggrod.emit(target)

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _draw() -> void:
	draw_circle(Vector2.ZERO, home_radius, Color.RED, false)
	draw_circle(Vector2.ZERO, collision_shape.shape.radius, Color.GREEN, false)

func notify_player_aggro(player: Player) -> void:
	player_aggrod.emit(player)


func _on_body_entered(body: Node2D) -> void:
	target = body

func _on_body_exited(body: Node2D) -> void:
	if target == body:
		target = null
