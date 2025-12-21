extends Node

var walking: bool = false

@onready var music_gameplay: AudioStreamPlayer = $MusicGameplay

@onready var sfxEnemyDestroyed: AudioStreamPlayer = $SFXEnemyDestroyed
@onready var sfxEnvironmentRiftAreaClosed: AudioStreamPlayer = $SFXEnvironmentRiftAreaClosed
@onready var sfxEnvironmentRiftBigEruption: AudioStreamPlayer = $SFXEnvironmentRiftBigEruption
@onready var sfxPlayerHurt: AudioStreamPlayer = $SFXPlayerHurt
@onready var sfxUiClickConfirm: AudioStreamPlayer = $SFXUIClickConfirm
@onready var sfxUiMouseEntered: AudioStreamPlayer = $SFXUIMouseEntered
@onready var level_end_stinger: AudioStreamPlayer = $LevelEndStinger
@onready var into_level_1_stinger: AudioStreamPlayer = $IntoLevel1Stinger
@onready var game_over_stinger: AudioStreamPlayer = $GameOverStinger
@onready var sfx_enemy_hurt: AudioStreamPlayer = $SFXEnemyHurt
@onready var sfx_slime_shooting: AudioStreamPlayer = $SFXSlimeShooting
@onready var sfx_slime_walking: AudioStreamPlayer = $SFXSlimeWalking
@onready var sfx_power_up_acquired: AudioStreamPlayer = $SFXPowerUpAcquired
@onready var sfx_rumble: AudioStreamPlayer = $SFXRumble
@onready var sfx_closing_rift: Array[AudioStreamPlayer] = [
	$SFXClosingRift1,
	$SFXClosingRift2,
	$SFXClosingRift3,
	$SFXClosingRift4,
]
@onready var sfx_talking: Array[AudioStreamPlayer] = [
	$"501SlimeTalking1",
	$"501SlimeTalking2",
	$"501SlimeTalking3",
	$"501SlimeTalking4",
	$"501SlimeTalking5",
	$"501SlimeTalking6Conclusion",
]

func _ready() -> void:
	EventBus.globalEnemyHurt.connect(_playSfxEnemyHurt)
	EventBus.globalEnemyDestroyed.connect(_playSfxEnemyDestroyed)
	EventBus.globalEnvironmentRiftAreaClosed.connect(_playSfxEnvironmentRiftAreaClosed)
	EventBus.globalEnvironmentRiftBigEruption.connect(_playSfxEnvironmentRiftBigEruption)
	EventBus.globalPlayerHurt.connect(_playSfxPlayerHurt)
	EventBus.globalUiElementMouseEntered.connect(_playSfxUiMouseEntered)
	EventBus.globalUiElementSelected.connect(_playSfxUiClickConfirm)
	EventBus.globalLevel1Started.connect(_playMusicGamplayLevel1)
	EventBus.globalLevelNStarted.connect(_playMusicGamplayLevelN)
	EventBus.globalLevelSuccess.connect(_playMusicGamplayLevelSuccess)
	EventBus.globalLevelFailed.connect(_playMusicGamplayLevelFailed)
	EventBus.globalIntermissionEntered.connect(_playMusicPowerupScreen)
	EventBus.globalTitleEntered.connect(_playMusicTitle)
	EventBus.globalInitialDialogStarted.connect(_playMusicIntroDialog)
	EventBus.globalCreditsEntered.connect(_playMusicEndCredits)
	EventBus.globalPlayerShoot.connect(_playPlayerShoot)
	EventBus.globalPlayerWalkStart.connect(_playPlayerWalkStart)
	EventBus.globalPlayerWalkEnd.connect(_playPlayerWalkEnd)
	EventBus.globalPlayerPowerup.connect(_playPlayerPowerup)
	EventBus.globalEnvironmentRiftBigReadyToLaunch.connect(_playRumble)
	EventBus.globalEnvironmentRiftBigReadyToLaunchReset.connect(_playRumbleStop)
	EventBus.globalRiftSealProgress.connect(_playRiftProgress)
	EventBus.globalTalk.connect(_playTalk)

func _playTalk(i: int) -> void:
	if i < 0:
		for s in sfx_talking:
			s.stop()
	else:
		sfx_talking[i].play()

#region Music
func _playMusicTitle() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Title Track"
	EventBus.globalMusicTrackPlaying.emit("Title")
func _playMusicIntroDialog() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Initial Dialogue Track"
	EventBus.globalMusicTrackPlaying.emit("Initial Dialogue")
func _playMusicEndCredits() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Endgame And Credits"
	EventBus.globalMusicTrackPlaying.emit("Endgame And Credits")
func _playMusicGamplayLevel1() -> void:
	into_level_1_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Level 1 Track"
	EventBus.globalMusicTrackPlaying.emit("Level 1")
func _playMusicGamplayLevelN() -> void:
	into_level_1_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Level 1 Track"
	EventBus.globalMusicTrackPlaying.emit("Level 1")
func _playMusicGamplayLevelSuccess() -> void:
	level_end_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Endgame And Credits"
	EventBus.globalMusicTrackPlaying.emit("Endgame And Credits")
func _playMusicGamplayLevelFailed() -> void:
	game_over_stinger.play()
	music_gameplay["parameters/switch_to_clip"] = "Endgame And Credits"
	EventBus.globalMusicTrackPlaying.emit("Endgame And Credits")
func _playMusicPowerupScreen() -> void:
	music_gameplay["parameters/switch_to_clip"] = "Powerup Screen Track"
	EventBus.globalMusicTrackPlaying.emit("Powerup Screen")
#endregion Music

#region Enemy
func _playSfxEnemyHurt() -> void:
	sfx_enemy_hurt.play()
func _playSfxEnemyDestroyed() -> void:
	sfxEnemyDestroyed.play()
#endregion Enemy

#region Environment
func _playSfxEnvironmentRiftAreaClosed(_vent: VentHole) -> void:
	sfxEnvironmentRiftAreaClosed.play()

func _playSfxEnvironmentRiftBigEruption() -> void:
	sfxEnvironmentRiftBigEruption.play()

func _playRiftProgress(i: int) -> void:
	sfx_closing_rift[i].play()

func _playRumble() -> void:
	sfx_rumble.play()
func _playRumbleStop() -> void:
	sfx_rumble.stop()
#endregion Environment

#region Player
func _playSfxPlayerHurt() -> void:
	sfxPlayerHurt.play()
func _playPlayerShoot() -> void:
	sfx_slime_shooting.play()
func _playPlayerPowerup() -> void:
	sfx_power_up_acquired.play()
func _playPlayerWalkStart() -> void:
	if not sfx_slime_walking.playing:
		sfx_slime_walking.play()
	walking = true
func _playPlayerWalkEnd() -> void:
	walking = false
#endregion Player

#region UI
func _playSfxUiClickConfirm() -> void:
	sfxUiMouseEntered.stop()
	sfxUiClickConfirm.play()

func _playSfxUiMouseEntered() -> void:
	sfxUiMouseEntered.play()
#endregion UI


func _on_sfx_slime_walking_finished() -> void:
	if walking:
		sfx_slime_walking.play()
