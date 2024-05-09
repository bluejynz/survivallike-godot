extends Node

@export var speed: float = 1

var enemy: Enemy
var sprite: AnimatedSprite2D
var detection_area: Area2D
var is_running: bool = false

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	detection_area = enemy.get_node("DetectionArea")

func _process(delta: float) -> void:
	detect_player()
	play_run_idle_animation()

func _physics_process(delta: float) -> void:
	if is_running:
		var difference = GameManager.player_position - enemy.position
		var input_vector = -difference.normalized()
		enemy.velocity = input_vector * speed * 100
		
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
		
		is_running = true;
		enemy.move_and_slide()

func detect_player() -> void:
	var areas = detection_area.get_overlapping_areas()
	for area in areas:
		if area.is_in_group("player"):
			is_running = true;
		else:
			is_running = false;
		print("Detected: ", is_running)

func play_run_idle_animation() -> void:
	if is_running:
		sprite.play("run")
	else:
		sprite.play("idle")
