class_name GameUI
extends CanvasLayer

@onready var timer_label: Label = %TimerLabel
@onready var gold_label: Label = %GoldLabel
@onready var level_label: Label = %LevelLabel

func _ready():
	gold_label.text = str(GameManager.gold_count)
	level_label.text = str(GameManager.player.level)
	GameManager.level_up.connect(updateLevel)

func _process(delta):
	gold_label.text = str(GameManager.gold_count)
	timer_label.text = GameManager.elapsed_time_text

func updateLevel():
	level_label.text = str(GameManager.player.level)
