extends Node

var wipe_cooldown: float = 0
var wipe_interval: float = 30

func _ready():
	wipe_cooldown = wipe_interval

func _process(delta):
	if GameManager.is_game_over: return
	
	update_cooldown(delta)

func get_and_wipe_all_enemies():
	var enemies = GameManager.get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		if not is_on_screen(enemy):
			enemy.queue_free()

func get_and_wipe_all_items():
	var items = GameManager.get_tree().get_nodes_in_group("items")
	for item in items:
		if not is_on_screen(item):
			item.queue_free()

func is_on_screen(object) -> bool:
	var viewport = get_viewport().get_visible_rect()
	var camera = get_viewport().get_camera_2d()
	
	if camera:
		var global_position = object.global_position
		var camera_position = camera.global_position
		var screen_rect = Rect2(camera_position - viewport.size / 2, viewport.size)
		
		if not screen_rect.has_point(global_position):
			return false

	return true

func update_cooldown(delta: float):
	wipe_cooldown -= delta
	if wipe_cooldown > 0: return
	
	get_and_wipe_all_enemies()
	get_and_wipe_all_items()
	wipe_cooldown = wipe_interval
