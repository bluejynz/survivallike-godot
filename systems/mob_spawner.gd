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
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask = 0b1000
	
	var result: Array = world_state.intersect_point(parameters, 1)
	if not result.is_empty(): return
	
	var index = randi_range(0, creatures.size() - 1)
	var creature_prefab = creatures[index]
	var creature = creature_prefab.instantiate()
	creature.global_position = point
	get_parent().add_child(creature)

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position
