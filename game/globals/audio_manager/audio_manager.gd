extends Node

@onready var sfxEnemyDestroyed: AudioStreamPlayer = $SFXEnemyDestroyed
@onready var sfxEnvironmentRiftAreaClosed: AudioStreamPlayer = $SFXEnvironmentRiftAreaClosed
@onready var sfxEnvironmentRiftBigEruption: AudioStreamPlayer = $SFXEnvironmentRiftBigEruption
@onready var sfxPlayerHurt: AudioStreamPlayer = $SFXPlayerHurt
@onready var sfxUiClickConfirm: AudioStreamPlayer = $SFXUIClickConfirm
@onready var sfxUiMouseEntered: AudioStreamPlayer = $SFXUIMouseEntered

func _ready() -> void:
	EventBus.globalEnemyDestroyed.connect(_playSfxEnemyDestroyed)
	EventBus.globalEnvironmentRiftAreaClosed.connect(_playSfxEnvironmentRiftAreaClosed)
	EventBus.globalEnvironmentRiftBigEruption.connect(_playSfxEnvironmentRiftBigEruption)
	EventBus.globalPlayerHurt.connect(_playSfxPlayerHurt)
	EventBus.globalUiElementMouseEntered.connect(_playSfxUiMouseEntered)
	EventBus.globalUiElementSelected.connect(_playSfxUiClickConfirm)

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
