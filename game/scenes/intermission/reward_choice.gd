extends Sprite2D

@export var upgrade: PlayerStats.Upgrade:
	set(v):
		upgrade = v
		if sprite_2d:
			sprite_2d.texture = PlayerStats.get_upgrade_icon(upgrade)
		if label:
			label.text = PlayerStats.Upgrade.find_key(upgrade)

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var label: Label = $Label

var _time: float = 0.0

func _ready() -> void:
	sprite_2d.texture = PlayerStats.get_upgrade_icon(upgrade)
	label.text = PlayerStats.Upgrade.find_key(upgrade)

func _process(delta: float) -> void:
	_time += delta
	rotation = sin(_time) * 0.3
