extends CanvasLayer

@onready var timer_label: Label = %TimerLabel

var elapsed_time: float = 0

func _process(delta):
	elapsed_time += delta
	var elapsed_time_in_seconds: int = floori(elapsed_time)
	var seconds: int = elapsed_time_in_seconds % 60
	var minutes: int = elapsed_time_in_seconds / 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
