extends CanvasLayer

@onready var label: RichTextLabel = $Control/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.globalMusicTrackPlaying.connect(_play)

func _play(track: String) -> void:
	label.text = "[wave][img]res://assets/note.png[/img] %s[/wave]" % [track]
	animation_player.stop()
	animation_player.play("toast")
	print("foor! ", track)
