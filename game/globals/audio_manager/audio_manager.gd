extends Node

var current_music: AudioStreamPlayer

@onready var music_gameplay: AudioStreamPlayer = $MusicGameplay

@onready var sfxEnemyDestroyed: AudioStreamPlayer = $SFXEnemyDestroyed
@onready var sfxEnvironmentRiftAreaClosed: AudioStreamPlayer = $SFXEnvironmentRiftAreaClosed
@onready var sfxEnvironmentRiftBigEruption: AudioStreamPlayer = $SFXEnvironmentRiftBigEruption
@onready var sfxPlayerHurt: AudioStreamPlayer = $SFXPlayerHurt
@onready var sfxUiClickConfirm: AudioStreamPlayer = $SFXUIClickConfirm
@onready var sfxUiMouseEntered: AudioStreamPlayer = $SFXUIMouseEntered
@onready var level_end_stinger: AudioStreamPlayer = $LevelEndStinger
@onready var into_level_1_stinger: AudioStreamPlayer = $IntoLevel1Stinger

func _ready() -> void:
	EventBus.globalEnemyDestroyed.connect(_playSfxEnemyDestroyed)
	EventBus.globalEnvironmentRiftAreaClosed.connect(_playSfxEnvironmentRiftAreaClosed)
	EventBus.globalEnvironmentRiftBigEruption.connect(_playSfxEnvironmentRiftBigEruption)
	EventBus.globalPlayerHurt.connect(_playSfxPlayerHurt)
	EventBus.globalUiElementMouseEntered.connect(_playSfxUiMouseEntered)
	EventBus.globalUiElementSelected.connect(_playSfxUiClickConfirm)
	EventBus.globalLevel1Started.connect(_playMusicGamplayLevel1)
	EventBus.globalLevelNStarted.connect(_playMusicGamplayLevelN)
	EventBus.globalLevelSuccess.connect(_playMusicGamplayLevelEnd)
	EventBus.globalLevelFailed.connect(_playMusicGamplayLevelEnd)
	EventBus.globalIntermissionEntered.connect(_playMusicPowerupScreen)
	EventBus.globalTitleEntered.connect(_playMusicTitle)
	EventBus.globalCreditsEntered.connect(_playMusicEndCredits)

#region Music
func _playMusicTitle() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Title Track"
func _playMusicEndCredits() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Endgame And Credits"
func _playMusicGamplayLevel1() -> void:
	into_level_1_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Level 1 Track"
func _playMusicGamplayLevelN() -> void:
	into_level_1_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Level 1 Track"
func _playMusicGamplayLevelEnd() -> void:
	music_gameplay["parameters/switch_to_clip"] = "silence"
func _playMusicPowerupScreen() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Powerup Screen Track"
#endregion Music

#region Enemy
func _playSfxEnemyDestroyed() -> void:
	sfxEnemyDestroyed.play()
#endregion Enemy

#region Environment
func _playSfxEnvironmentRiftAreaClosed() -> void:
	sfxEnvironmentRiftAreaClosed.play()

func _playSfxEnvironmentRiftBigEruption() -> void:
	sfxEnvironmentRiftBigEruption.play()
#endregion Environment

#region Player
func _playSfxPlayerHurt() -> void:
	sfxPlayerHurt.play()
#endregion Player

#region UI
func _playSfxUiClickConfirm() -> void:
	sfxUiClickConfirm.play()

func _playSfxUiMouseEntered() -> void:
	sfxUiMouseEntered.play()
#endregion UI
