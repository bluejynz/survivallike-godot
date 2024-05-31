class_name LevelUpUI
extends CanvasLayer

@onready var panels: Array[Panel] = [
		$Panel/ItemList/Panel1, 
		$Panel/ItemList/Panel2, 
		$Panel/ItemList/Panel3
	]

func _ready():
	GameManager.toggle_pause()
	update_labels()

func _process(delta):
	if GameManager.is_game_over: dispose_menu()

func update_labels():
	for panel in panels:
		var label = panel.get_child(0)
		match panel.name:
			"Panel1":
				if GameManager.player.is_sword_damage_caps():
					label.text = "Sword Damage (Max)"
				else:
					label.text = "Sword Damage +1 (%d)" % [GameManager.player.sword_damage+1]
			"Panel2":
				label.text = "Max Health +2 (%d)" % [GameManager.player.max_health+2]
			"Panel3":
				if GameManager.player.is_ritual_interval_caps():
					label.text = "Ritual Cooldown (Max)"
				else:
					label.text = "Ritual Cooldown -1s (%ds)" % [GameManager.player.ritual_interval-1]
 
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			for panel in panels:
				var rect = Rect2(panel.get_global_rect().position, panel.size)
				if rect.has_point(event.global_position):
					select_option(panel)

func select_option(panel: Panel):
	match panel.name:
		"Panel1":
			if GameManager.player.is_sword_damage_caps(): return
			else: GameManager.player.upgrade_sword_damage(1)
		"Panel2":
			GameManager.player.upgrade_max_health(2)
		"Panel3":
			if GameManager.player.is_ritual_interval_caps(): return
			else: GameManager.player.reduce_ritual_interval(1)
	
	dispose_menu()

func dispose_menu():
	GameManager.toggle_pause()
	queue_free()
