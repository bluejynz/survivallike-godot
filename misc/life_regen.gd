extends Node2D

@export var regen_amount: int = 10

@onready var chew_sound = preload("res://addons/sounds/chew.wav")
@onready var heal_sound = preload("res://addons/sounds/heal.wav")
@onready var audio_player: PackedScene = preload("res://misc/audio_player.tscn")

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regen_amount)
		
		var audio = audio_player.instantiate()
		audio.position = position
		get_tree().root.add_child(audio)
		
		audio.play_audio(chew_sound)
		if(player.health >= player.max_health):
			audio.play_audio(heal_sound)
		
		queue_free()
	
