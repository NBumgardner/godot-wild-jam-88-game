extends Node2D

const SCROLL_SPEED = 1200.0
const SELECT_SPEED = 1600.0

var _selection: int = 1

var _input_disabled: bool = false

@onready var parallax_2d: Parallax2D = $Parallax2D
@onready var player_selector: Node2D = $PlayerSelector
@onready var markers: Array[Marker2D] = [
	$Marker1,
	$Marker2,
	$Marker3,
]
@onready var rewards: Array[Node2D] = [
	$Intermission,
	$Intermission2,
	$Intermission3,
]
@onready var color_rect: ColorRect = $CanvasLayer/ColorRect

func _ready() -> void:
	EventBus.globalIntermissionEntered.emit()
	if GameState.current_level == 4:
		rewards[1].visible = false
		rewards.remove_at(1)
		markers.remove_at(1)
		var possible_rewards := PlayerStats.KeyUpgrade.values()
		for i in 2:
			rewards[i].upgrade = possible_rewards[i]
		_selection = 0
	else:
		var possible_rewards := PlayerStats.Upgrade.values().filter(func (u): return u not in PlayerStats.KeyUpgrade.values())
		possible_rewards.append_array(possible_rewards.filter(func (u): return not PlayerStats.is_upgrade_rare(u)))
		possible_rewards.shuffle()
		for i in 3:
			rewards[i].upgrade = possible_rewards[i]
	for i in rewards.size():
		rewards[i].clicked.connect(_on_intermission_clicked.bind(i))
		rewards[i].hovered.connect(_on_intermission_hovered.bind(i))

func _process(delta: float) -> void:
	if not _input_disabled:
		if Input.is_action_just_pressed("move_left"):
			_selection = clampi(_selection - 1, 0, rewards.size() - 1)
		if Input.is_action_just_pressed("move_right"):
			_selection = clampi(_selection + 1, 0, rewards.size() - 1)
		if Input.is_action_just_pressed("❌_button"):
			_take_upgrade()
	
	parallax_2d.scroll_offset.y += delta * SCROLL_SPEED
	player_selector.position = player_selector.position.lerp(markers[_selection].position, 1.0 - exp(-delta * 10.0))

func _take_upgrade() -> void:
	_input_disabled = true
	GameState.player_stats.add_upgrade(rewards[_selection].upgrade)
	EventBus.globalPlayerPowerup.emit()
	
	var t := create_tween()
	t.tween_property(markers[_selection], "position:y", -600.0, 0.5).as_relative().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	t.tween_property(markers[_selection], "position:y", -1600.0, 0.5).as_relative()
	t.parallel().tween_property(color_rect, "color:a", 1.0, 0.5).as_relative()
	
	if rewards.size() == 3:
		for i in range(1, 3):
			var tt := create_tween()
			tt.tween_property(rewards[(_selection + i) % 3], "position:y", 320.0, 1.0).as_relative().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
			tt.parallel().tween_property(rewards[(_selection + i) % 3], "position:x", 0.5 * (rewards[(_selection + i) % 3].position.x - rewards[_selection].position.x), 1.0).as_relative()
	else:
		var i = 1 - _selection
		var tt := create_tween()
		tt.tween_property(rewards[i], "position:y", 320.0, 1.0).as_relative().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
		tt.parallel().tween_property(rewards[i], "position:x", 0.5 * (rewards[i].position.x - rewards[_selection].position.x), 1.0).as_relative()
	
	await t.finished
	
	GameState.start_level()


func _on_intermission_hovered(i: int) -> void:
	_selection = i


func _on_intermission_clicked(i: int) -> void:
	_selection = i
	_take_upgrade()
