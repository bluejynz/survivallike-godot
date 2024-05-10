extends Node2D

@onready var path_follow_2d: PathFollow2D = %Path2D/PathFollow2D

@export var creatures: Array[PackedScene]

func _process(delta: float) -> void:
	pass

func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.position
