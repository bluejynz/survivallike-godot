class_name XpBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
var max_xp: int = 100
var current_xp: int = 0

func _ready():
	progress_bar.max_value = max_xp
	progress_bar.value = current_xp
	GameManager.mob_killed.connect(gain_xp)

func gain_xp(value: int) -> void:
	current_xp += value
	level_up()
	progress_bar.value = current_xp

func level_up():
	if current_xp >= max_xp:
		current_xp = 0
		GameManager.player.level += 1
		max_xp += 20
		progress_bar.max_value = max_xp
		GameManager.level_up.emit()
