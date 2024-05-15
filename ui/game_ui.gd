extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel

var elapsed_time: float = 0
var gold_count: int = 0

func _ready():
	GameManager.gold_collected.connect(on_gold_collected)
	gold_label.text = str(gold_count)

func _process(delta):
	elapsed_time += delta
	var elapsed_time_in_seconds: int = floori(elapsed_time)
	var seconds: int = elapsed_time_in_seconds % 60
	var minutes: int = elapsed_time_in_seconds / 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]

func on_gold_collected() -> void:
	gold_count += (randi_range(3, 5) * 5)
	gold_label.text = str(gold_count)
