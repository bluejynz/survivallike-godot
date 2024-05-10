extends Node2D

@onready var path_follow_2d: PathFollow2D = %PathFollow2D

@export var creatures: Array[PackedScene]
@export var mobs_per_minute: float = 60
var cooldown: float = 0

func _process(delta: float) -> void:
	cooldown -= delta
	if cooldown > 0: return
	
	var interval = 60 / mobs_per_minute
	cooldown = interval
	
	spawn_creature()

func spawn_creature() -> void:
	var index = randi_range(0, creatures.size() - 1)
	var creature_prefab = creatures[index]
	var creature = creature_prefab.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
