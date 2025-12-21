extends Sprite2D

signal hovered()
signal clicked()

@export var upgrade: PlayerStats.Upgrade:
	set(v):
		upgrade = v
		_update()

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label
@onready var rare_shine: Polygon2D = $RareShine

var _time: float = 0.0

func _ready() -> void:
	_update()

func _process(delta: float) -> void:
	_time += delta
	rotation = sin(_time) * 0.3
	rare_shine.rotation += delta
	rare_shine.scale = Vector2.ONE * abs(sin(_time))

func _update() -> void:
	if not is_inside_tree():
		return
	sprite_2d.texture = PlayerStats.get_upgrade_icon(upgrade)
	label.text = PlayerStats.get_upgrade_name(upgrade)
	if PlayerStats.is_upgrade_rare(upgrade):
		rare_shine.visible = true
		self_modulate = Color(1.0, 0.75, 0.0, 1.0)
		rare_shine.self_modulate = self_modulate
	else:
		rare_shine.visible = false
		self_modulate = Color.WHITE


func _on_area_2d_mouse_entered() -> void:
	hovered.emit()


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			clicked.emit()
