class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %MonstersLabel

@export var restart_delay: float = 10

var restart_cooldown: float

func _ready():
	time_label.text = GameManager.elapsed_time_text
	monsters_label.text = str(GameManager.monsters_slayed)
	restart_cooldown = restart_delay

func _process(delta: float) -> void:
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()

func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()
