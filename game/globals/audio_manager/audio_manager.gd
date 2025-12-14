extends Node

@onready var sfxUiClickConfirm = $SFXUIClickConfirm
@onready var sfxUiMouseEntered = $SFXUIMouseEntered

func _ready() -> void:
	EventBus.globalUiElementMouseEntered.connect(_playSfxUiMouseEntered)
	EventBus.globalUiElementSelected.connect(_playSfxUiClickConfirm)

#region UI
func _playSfxUiClickConfirm() -> void:
	sfxUiClickConfirm.play()

func _playSfxUiMouseEntered() -> void:
	sfxUiMouseEntered.play()
#endregion UI
