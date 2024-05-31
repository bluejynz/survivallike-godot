extends Node2D

@onready var area: Area2D = $Area2D

@export var damage_amount: int = 1

func deal_damage() -> void:
	if GameManager.is_game_paused: return
	
	var bodies = area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			enemy.damage(damage_amount)
	pass
