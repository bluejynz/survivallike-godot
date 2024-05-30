class_name GameOverUI
extends CanvasLayer

@onready var time_label: Label = %TimeLabel
@onready var monsters_label: Label = %MonstersLabel
@onready var countdown_label: Label = %RestartCountdownLabel

@export var restart_delay: float = 10

var restart_cooldown: float

func _ready():
	time_label.text = GameManager.elapsed_time_text
	monsters_label.text = str(GameManager.monsters_slayed)
	restart_cooldown = restart_delay

func _process(delta: float) -> void:
	updateCountdownLabel()
	restart_cooldown -= delta
	if restart_cooldown <= 0:
		restart_game()

func _input(event):
	if event is InputEventMouseButton:
		restart_cooldown = 0

func restart_game():
	GameManager.reset()
	get_tree().reload_current_scene()

func updateCountdownLabel():
	var countdown: int = ceili(restart_cooldown) % 60
	countdown_label.text = "Restarting in %d seconds..." % countdown
