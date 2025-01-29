class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea
@onready var health_bar: ProgressBar = $HealtBar/ProgressBar
@onready var damage_digit_marker = $DamageDigitMarker

@onready var damage_sound: AudioStreamPlayer2D = $SoundsNode/DamageAudio
@onready var death_sound: AudioStreamPlayer2D = $SoundsNode/DeathAudio

@export_category("Movement")
@export var speed: float = 2
var speed_caps: float = 4

@export_category("Sword")
@export var sword_damage: int = 1
#@export var attack_speed: float = 1
@export var knockback_strength: float = 10
@export var block_strength: float = 50
var block_speed: float = 2
var block_speed_caps: float = 1.5

@export_category("Ritual")
@export var ritual_damage: int = 1
@export var ritual_interval: float = 15
@export var ritual_prefab: PackedScene

@export_category("Life")
@export var death_prefab: PackedScene
@export var max_health: int = 100
@export var health: int = 100

var level: int = 0

var knockback_strength_caps: float = 30

var input_vector: Vector2 = Vector2(0, 0)
var attack_cooldown: float = 0
var block_cooldown: float = 0
var block_speed_cooldown: float = 0
var hitbox_cooldown: float = 0
var ritual_cooldown: float = 0
var is_running: bool = false
var was_running: bool = false
var is_attacking: bool = false
var is_blocking: bool = false
var is_block_available: bool = true

var max_sword_damage: int = 10
var max_ritual_damage: int = 2
var min_ritual_interval: int = 8

var damage_digit_prefab: PackedScene
var level_up_display_prefab: PackedScene

func _ready():
	#TODO: remove this
	#speed = 3
	#sword_damage = 20
	#
	GameManager.player = self
	damage_digit_prefab = preload("res://ui/damage_digit.tscn")
	level_up_display_prefab = preload("res://ui/level_up_display.tscn")
	GameManager.level_up.connect(level_up)
	death_sound.connect("finished", Callable(self, "_on_death_audio_finished"))

func _process(delta: float) -> void:
	if GameManager.is_game_paused: return
	
	GameManager.player_position = position
	read_input()
	
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack_1"):
		attack()
	
	update_block_cooldown(delta)
	update_block_speed_cooldown(delta)
	if Input.is_action_just_pressed("block"):
		block()
	
	play_run_idle_animation()
	if not is_attacking and not is_blocking:
		rotate_sprite()
	
	update_hitbox_detection(delta)
	update_ritual(delta)
	
	health_bar.max_value = max_health
	health_bar.value = health

func _physics_process(delta: float) -> void:
	if GameManager.is_game_paused: return
	
	var target_velocity = input_vector * speed * 100
	if is_attacking or is_blocking:
		target_velocity *= .25
	velocity = lerp(velocity, target_velocity, .05)
	move_and_slide()

func read_input() -> void:
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var deadzone = .15
	if abs(input_vector.x) < deadzone:
		input_vector.x = 0
	if abs(input_vector.y) < deadzone:
		input_vector.y = 0
	
	was_running = is_running
	is_running = not input_vector.is_zero_approx()

func play_run_idle_animation() -> void:
	if not is_attacking and not is_blocking:
		if was_running != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func rotate_sprite() -> void:
	if input_vector.x > 0:
		sprite.flip_h = false
	elif input_vector.x < 0:
		sprite.flip_h = true

func attack() -> void:
	if is_attacking: return
	animation_player.play("attack_side_1")
	
	is_attacking = true
	attack_cooldown = .6

func block() -> void:
	if is_blocking or not is_block_available: return
	animation_player.play("attack_side_2")
	
	is_blocking = true
	is_block_available = false
	block_cooldown = .6
	block_speed_cooldown = block_speed

func deal_damage_to_enemies(knockback: bool) -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			knock_enemies_back(body, true)

func deal_knockback_to_enemies() -> void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			knock_enemies_back(body, true, true)

func knock_enemies_back(enemy: Enemy, do_damage: bool, block: bool = false) -> void:
	var direction_to_enemy = (enemy.position - position).normalized()
	var attack_direction: Vector2
	
	if sprite.flip_h:
		attack_direction = Vector2.LEFT
	else:
		attack_direction = Vector2.RIGHT
	
	var dot_product = direction_to_enemy.dot(attack_direction)
	if dot_product > .4:
		if do_damage:
			enemy.damage(sword_damage)
		if block:
			enemy.knockback(block_strength)
		else:
			enemy.knockback(knockback_strength)

func update_attack_cooldown(delta: float) -> void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func update_block_cooldown(delta: float) -> void:
	if is_blocking:
		block_cooldown -= delta
		if block_cooldown <= 0:
			is_blocking = false
			is_running = false
			animation_player.play("idle")

func update_block_speed_cooldown(delta: float) -> void:
	if not is_block_available:
		block_speed_cooldown -= delta
		if block_speed_cooldown <= 0:
			is_block_available = true

func update_hitbox_detection(delta: float) -> void:
	hitbox_cooldown -= delta
	if(hitbox_cooldown > 0): return
	
	hitbox_cooldown = .5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("animals"): return
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			if not is_blocking:
				damage(enemy.hit_damage)

func damage(amount: int) -> void:
	if(health <= 0): return
	health -= amount
	
	modulate = Color.INDIAN_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, .2)
	damage_sound.play()
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.end_game()
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	death_sound.play()

func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health

func update_ritual(delta: float) -> void:
	ritual_cooldown -= delta
	if ritual_cooldown > 0: return
	ritual_cooldown = ritual_interval
	
	var ritual = ritual_prefab.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)

func level_up():
	modulate = Color(2, 2, 1.5)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 1)
	
	var level_up_display = level_up_display_prefab.instantiate()
	if damage_digit_marker:
		level_up_display.global_position = damage_digit_marker.global_position
	else:
		level_up_display.global_position = global_position
	get_parent().add_child(level_up_display)

func _on_death_audio_finished():
	queue_free()

func upgrade_max_health(amount: int):
	max_health += amount

func upgrade_sword_damage(amount: int):
	sword_damage += amount

func is_sword_damage_caps() -> bool:
	if sword_damage >= max_sword_damage: return true
	else: return false

func upgrade_ritual_damage(amount: int):
	ritual_damage += amount

func is_ritual_damage_caps() -> bool:
	if ritual_damage >= max_ritual_damage: return true
	else: return false

func reduce_ritual_interval(amount: int):
	ritual_interval -= amount

func is_ritual_interval_caps() -> bool:
	if ritual_interval <= min_ritual_interval: return true
	else: return false

func upgrade_knockback_strength():
	knockback_strength += knockback_strength * 0.08

func is_knockback_strength_caps() -> bool:
	if knockback_strength >= knockback_strength_caps: return true
	else: return false

func upgrade_move_speed():
	speed += speed * 0.05

func is_move_speed_caps() -> bool:
	if speed >= speed_caps: return true
	else: return false

func receive_gold(amount: int):
	GameManager.gold_count += amount

func upgrade_block_speed():
	block_speed -= block_speed * 0.1

func is_block_speed_caps() -> bool:
	if block_speed <= block_speed_caps: return true
	else: return false
