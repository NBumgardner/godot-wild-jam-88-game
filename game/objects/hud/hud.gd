extends Control

@export var game_manager: GameManager
@export var player: Player

@onready var label: Label = $%LabelGoalReminder
@onready var health_bar: Label = %HealthBar
@onready var health_bar_final: Node2D = $HealthBar2
@onready var health_bar_mask: ColorRect = $HealthBar2/health_mask
@onready var health_bar_ice: Sprite2D = $HealthBar2/HTherm
@onready var hud_anim: AnimationPlayer = $HUDAnim
@onready var upgrade_icons: HBoxContainer = $UpgradeIcons

func _ready() -> void:
	_update_text()
	EventBus.globalPlayerHurt.connect(func ():
		hud_anim.play("HEALTH_BAR_SHAKE"))
	
	_reconcile_upgrades()
	GameState.player_stats.upgrades_changed.connect(_reconcile_upgrades)

func _reconcile_upgrades() -> void:
	for c in upgrade_icons.get_children():
		c.queue_free()
		upgrade_icons.remove_child(c)
	
	for ug in GameState.player_stats.upgrades:
		var rect := TextureRect.new()
		rect.texture = PlayerStats.get_upgrade_icon(ug)
		rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		upgrade_icons.add_child(rect)

func _process(_delta: float) -> void:
	_update_text()

func _update_text() -> void:
	if game_manager and game_manager.remaining_vents > 0:
		label.text = "Remaining vents: %s" % game_manager.remaining_vents
	else:
		label.text = "Get to the MEGA VENT!!!!!"
	
	health_bar.text = "❤️".repeat(player.current_hp) + "❌".repeat(GameState.player_stats.max_hp - player.current_hp)
	handle_healthbar()

func handle_healthbar() -> void:
	if player.current_hp > 0:
		health_bar_mask.size.x = remap(player.current_hp,1,GameState.player_stats.max_hp,39,229)
	else:
		health_bar_mask.size.x = 0
	var health_stage = round(remap(player.current_hp,0,GameState.player_stats.max_hp,0,5))
	health_bar_ice.frame = health_stage
	if health_stage > 3:
		health_bar_mask.modulate = Color(0.842, 0.0, 0.212, 1.0)
	elif health_stage > 2:
		health_bar_mask.modulate = Color(0.792, 0.136, 0.673, 1.0)
	else:
		health_bar_mask.modulate = Color(0.106, 0.629, 1.0, 1.0)

#region SFX
func _on_button_quit_mouse_entered():
	EventBus.globalUiElementMouseEntered.emit()

func _on_button_quit_pressed():
	EventBus.globalUiElementSelected.emit()
	get_tree().change_scene_to_file("res://scenes/menus/start_menu/start_menu.tscn")
#endregion SFX
