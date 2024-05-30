class_name Enemy
extends Node2D

@export_category("Life")
@export var health: int = 10
@export var hit_damage: int = 1

@export_category("Drops")
#@export var drop_chance: float = .1
@export var drop_items_and_chance: Dictionary #[PackedScene, float]
@export var xp_given: int = 50

var damage_digit_prefab: PackedScene
var meat_prefab: PackedScene
var death_prefab: PackedScene

@onready var damage_digit_marker = $DamageDigitMarker
@onready var health_bar: ProgressBar = $HealtBar/ProgressBar

func _ready():
	damage_digit_prefab = preload("res://ui/damage_digit.tscn")
	meat_prefab = preload("res://misc/meat.tscn")
	death_prefab = preload("res://misc/skull.tscn")
	health_bar.max_value = health

func _process(delta):
	health_bar.value = health

func damage(amount: int) -> void:
	health -= amount
	
	modulate = Color.INDIAN_RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, .2)
	
	var damage_digit = damage_digit_prefab.instantiate()
	damage_digit.value = amount
	if damage_digit_marker:
		damage_digit.global_position = damage_digit_marker.global_position
	else:
		damage_digit.global_position = global_position
	get_parent().add_child(damage_digit)
	
	if health <= 0:
		die()

func die() -> void:
	GameManager.monsters_slayed += 1
	
	if death_prefab:
		var death_object = death_prefab.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	drop_items()
	GameManager.mob_killed.emit(xp_given)
	
	queue_free()

func drop_items() -> void:
	for item in drop_items_and_chance:
		if randf() <= drop_items_and_chance[item]:
			var item_object = item.instantiate()
			item_object.position = position
			get_parent().add_child(item_object)
