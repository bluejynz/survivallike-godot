extends AudioStreamPlayer

var current_music_index = 0

var music_playlist = [
	preload("res://addons/sounds/songs/song-1.mp3"),
	preload("res://addons/sounds/songs/song-2.mp3"),
	preload("res://addons/sounds/songs/song-3.mp3"),
	preload("res://addons/sounds/songs/song-4.mp3"),
	preload("res://addons/sounds/songs/song-5.mp3")
]

func _ready():
	connect("finished", Callable(self, "_on_music_finished"))
	play_music(current_music_index)

func play_music(index):
	stream = music_playlist[index]
	play()

func _on_music_finished():
	current_music_index += 1
	
	if current_music_index >= music_playlist.size():
		current_music_index = 0
	
	play_music(current_music_index)
