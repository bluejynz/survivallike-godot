class_name LevelUpUI
extends CanvasLayer

@onready var panels: Array[Panel] = [
		$Panel/ItemList/Panel1, 
		$Panel/ItemList/Panel2, 
		$Panel/ItemList/Panel3
	]

const UpgradesEnum = preload("res://player/upgrades_enum.gd").UpgradesEnum

var upgrades: Array[int]
var filtered_upgrades: Array[int]

func _ready():
	GameManager.toggle_pause()
	upgrades = random_upgrades()
	update_labels()

func _process(delta):
	if GameManager.is_game_over: dispose_menu()

func update_button_animation(panel: Panel, is_mouse_over: bool):
	if is_mouse_over:
		panel.modulate = Color.AQUAMARINE
	else:
		panel.modulate = Color.WHITE

func random_upgrades() -> Array[int]:
	filtered_upgrades = upgrades_without_caps()
	
	while upgrades.size() < 3:
		var rng = randi() % (filtered_upgrades.size())
		if not upgrades.has(filtered_upgrades[rng]):
			upgrades.append(filtered_upgrades[rng])
	
	return upgrades

func upgrades_without_caps() -> Array[int]:
	var filtered_upgrades: Array[int] = []
	for i in UpgradesEnum.values():
		match UpgradesEnum.find_key(i):
			"MOVE_SPEED":
				if not GameManager.player.is_move_speed_caps():
					filtered_upgrades.append(i)
			"SWORD_DAMAGE":
				if not GameManager.player.is_sword_damage_caps():
					filtered_upgrades.append(i)
			"RITUAL_DAMAGE":
				if not GameManager.player.is_ritual_damage_caps():
					filtered_upgrades.append(i)
			"RITUAL_INTERVAL":
				if not GameManager.player.is_ritual_interval_caps():
					filtered_upgrades.append(i)
			"MAX_HEALTH":
				filtered_upgrades.append(i)
			"KNOCKBACK_STRENGTH":
				if not GameManager.player.is_knockback_strength_caps():
					filtered_upgrades.append(i)
			"DEFAULT":
				filtered_upgrades.append(i)
	return filtered_upgrades

func update_label_text(index: int, label: Label):
	match UpgradesEnum.find_key(index):
		"MOVE_SPEED":
			if GameManager.player.is_move_speed_caps():
				label.text = "Movement Speed (Max)"
			else:
				var newSpeed: float = GameManager.player.speed+(GameManager.player.speed*0.05)
				label.text = "Movement Speed +5%"# ({})".format([newSpeed], "{}")
		"SWORD_DAMAGE":
			if GameManager.player.is_sword_damage_caps():
				label.text = "Sword Damage (Max)"
			else:
				label.text = "Sword Damage +1"# (%d)" % [GameManager.player.sword_damage+1]
		"RITUAL_DAMAGE":
			if GameManager.player.is_ritual_damage_caps():
				label.text = "Ritual Damage (Max)"
			else:
				label.text = "Ritual Damage +1"# (%d)" % [GameManager.player.ritual_damage+1]
		"RITUAL_INTERVAL":
			if GameManager.player.is_ritual_interval_caps():
				label.text = "Ritual Cooldown (Max)"
			else:
				label.text = "Ritual Cooldown -1s"# (%ds)" % [GameManager.player.ritual_interval-1]
		"MAX_HEALTH":
			label.text = "Max Health +2"# (%d)" % [GameManager.player.max_health+2]
		"KNOCKBACK_STRENGTH":
			if GameManager.player.is_knockback_strength_caps():
				label.text = "Knockback Strength (Max)"
			else:
				var newStrength: float = GameManager.player.knockback_strength+(GameManager.player.knockback_strength*0.08)
				label.text = "Knockback Strength +8%"# ({})".format([newStrength], "{}")
		"DEFAULT":
			var gold: int = GameManager.gold_count + 20
			label.text = "Gold +100"# ({})".format([newStrength], "{}")

func update_labels():
	for panel in panels:
		var label = panel.get_child(0)
		match panel.name:
			"Panel1":
				update_label_text(upgrades[0], label)
			"Panel2":
				update_label_text(upgrades[1], label)
			"Panel3":
				update_label_text(upgrades[2], label)
 
func _input(event):
	for panel in panels:
		if event is InputEventMouseButton:
			if event.button_index == 1 and event.pressed:
				if is_mouse_position_over_object(event, panel):
					select_option(panel)
		if event is InputEventMouseMotion:
			if is_mouse_position_over_object(event, panel):
				update_button_animation(panel, true)
			else:
				update_button_animation(panel, false)

func is_mouse_position_over_object(mouse, object) -> bool:
	var rect = Rect2(object.get_global_rect().position, object.size)
	if rect.has_point(mouse.global_position):
		return true
	return false

func select_option(panel: Panel):
	var option_chosen: bool = false
	match panel.name:
		"Panel1":
			option_chosen = handle_option(upgrades[0])
		"Panel2":
			option_chosen = handle_option(upgrades[1])
		"Panel3":
			option_chosen = handle_option(upgrades[2])
	
	if option_chosen:
		dispose_menu()

func handle_option(index: int) -> bool:
	match UpgradesEnum.find_key(index):
		"MOVE_SPEED":
			if GameManager.player.is_move_speed_caps():
				return false
			else:
				GameManager.player.upgrade_move_speed()
				return true
		"SWORD_DAMAGE":
			if GameManager.player.is_sword_damage_caps():
				return false
			else:
				GameManager.player.upgrade_sword_damage(1)
				return true
		"RITUAL_DAMAGE":
			if GameManager.player.is_ritual_damage_caps():
				return false
			else:
				GameManager.player.upgrade_ritual_damage(1)
				return true
		"RITUAL_INTERVAL":
			if GameManager.player.is_ritual_interval_caps():
				return false
			else:
				GameManager.player.reduce_ritual_interval(1)
				return true
		"MAX_HEALTH":
			GameManager.player.upgrade_max_health(2)
			return true
		"KNOCKBACK_STRENGTH":
			if GameManager.player.is_knockback_strength_caps():
				return false
			else:
				GameManager.player.upgrade_knockback_strength()
				return true
		"DEFAULT":
			GameManager.player.receive_gold(100)
			return true
	return false

func dispose_menu():
	GameManager.toggle_pause()
	queue_free()
