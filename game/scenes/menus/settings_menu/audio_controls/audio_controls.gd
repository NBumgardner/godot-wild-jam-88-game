extends Control

@onready var hSliderMasterVolume: HSlider = $HSliderMasterVolume
@onready var hSliderMusicVolume: HSlider = $HSliderMusicVolume
@onready var hSliderSfxVolume: HSlider = $HSliderSFXVolume

const audio_bus_index_master = 0
const audio_bus_index_music = 1
const audio_bus_index_sfx = 2
const expected_audio_bus_count = 3
const display_percentage_multiplier = 100

func _ready() -> void:
	hSliderMasterVolume.value = (
		db_to_linear(AudioServer.get_bus_volume_db(audio_bus_index_master))
		* display_percentage_multiplier
	)
	hSliderMusicVolume.value = (
		db_to_linear(AudioServer.get_bus_volume_db(audio_bus_index_music))
		* display_percentage_multiplier
	)
	hSliderSfxVolume.value = (
		db_to_linear(AudioServer.get_bus_volume_db(audio_bus_index_sfx))
		* display_percentage_multiplier
	)

func _on_h_slider_master_volume_value_changed(value):
	var updated_volume_db = linear_to_db(value / display_percentage_multiplier)
	AudioServer.set_bus_volume_db(audio_bus_index_master, updated_volume_db)

func _on_h_slider_music_volume_value_changed(value):
	var updated_volume_db = linear_to_db(value / display_percentage_multiplier)
	AudioServer.set_bus_volume_db(audio_bus_index_music, updated_volume_db)

func _on_h_slider_sfx_volume_value_changed(value):
	var updated_volume_db = linear_to_db(value / display_percentage_multiplier)
	AudioServer.set_bus_volume_db(audio_bus_index_sfx, updated_volume_db)
