extends Node

@export var speed: float = 1
@export var stop_interval: float = 2

var enemy: Enemy
var sprite: AnimatedSprite2D
var detection_area: Area2D
var is_running: bool = false
var is_stopping: bool = false
var stop_running_cooldown: float = 0

func _ready():
	enemy = get_parent()
	sprite = enemy.get_node("AnimatedSprite2D")
	detection_area = enemy.get_node("DetectionArea")
	set_deferred("monitoring", true)

func _process(delta: float) -> void:
	if GameManager.is_game_over or GameManager.is_game_paused: return
	
	detection_area.body_entered.connect(detect_player)
	detection_area.body_exited.connect(stop_running)
	
	play_run_idle_animation()
	update_stop_running_cooldown(delta)

func _physics_process(delta: float) -> void:
	if GameManager.is_game_over or GameManager.is_game_paused: return
	
	if is_running:
		var difference = GameManager.player_position - enemy.position
		var input_vector = -difference.normalized()
		var target_velocity = input_vector * speed * 100
		enemy.velocity = lerp(enemy.velocity, target_velocity, 1)
		
		if input_vector.x > 0:
			sprite.flip_h = false
		elif input_vector.x < 0:
			sprite.flip_h = true
		
		enemy.move_and_slide()

func play_run_idle_animation() -> void:
	if is_running:
		sprite.play("run")
	else:
		sprite.play("idle")

func detect_player(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_running = true
		is_stopping = false

func stop_running(body: Node2D) -> void:
	if not is_stopping and is_running:
		is_stopping = true
		stop_running_cooldown = stop_interval

func update_stop_running_cooldown(delta: float) -> void:
	if is_stopping:
		stop_running_cooldown -= delta
		if stop_running_cooldown <= 0:
			is_running = false
			is_stopping = false
