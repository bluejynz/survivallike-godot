extends AudioStreamPlayer2D

func _ready():
	connect("finished", Callable(self, "_on_audio_finished"))

func play_audio(audio_stream):
	self.stream = audio_stream
	self.play()

func _on_audio_finished():
	queue_free()
