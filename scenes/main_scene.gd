extends Node

@export var game_ui: CanvasLayer
@export var game_over_ui_template: PackedScene
@export var level_up_ui_template: PackedScene

func _ready():
	GameManager.game_over.connect(trigger_game_over)
	GameManager.level_up.connect(trigger_level_up)

func trigger_level_up():
	var level_up_ui: LevelUpUI = level_up_ui_template.instantiate()
	add_child(level_up_ui)

func trigger_game_over():
	if game_ui:
		game_ui.queue_free()
		game_ui = null
	
	var game_over_ui: GameOverUI = game_over_ui_template.instantiate()
	add_child(game_over_ui)
