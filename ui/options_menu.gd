extends Node

@onready var master_volume_slider: HSlider = $MasterVolumeSlider
@onready var music_volume_slider: HSlider = $MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = $SFXVolumeSlider

func _ready():
	master_volume_slider.connect("value_changed", Callable(self, "_on_master_volume_changed"))
	music_volume_slider.connect("value_changed", Callable(self, "_on_music_volume_changed"))
	sfx_volume_slider.connect("value_changed", Callable(self, "_on_sfx_volume_changed"))
	
	_on_master_volume_changed(master_volume_slider.value)
	_on_music_volume_changed(music_volume_slider.value)
	_on_sfx_volume_changed(sfx_volume_slider.value)

func _on_master_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_music_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_volume_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func linear_to_db(linear):
	return linear * 20 - 80
