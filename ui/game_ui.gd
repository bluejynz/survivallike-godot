extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel

func _ready():
	gold_label.text = str(GameManager.gold_count)

func _process(delta):
	gold_label.text = str(GameManager.gold_count)
	
	GameManager.elapsed_time += delta
	var elapsed_time_in_seconds: int = floori(GameManager.elapsed_time)
	var seconds: int = elapsed_time_in_seconds % 60
	var minutes: int = elapsed_time_in_seconds / 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
