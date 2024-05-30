class_name GameUI
extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel

func _ready():
	gold_label.text = str(GameManager.gold_count)

func _process(delta):
	gold_label.text = str(GameManager.gold_count)
	timer_label.text = GameManager.elapsed_time_text
