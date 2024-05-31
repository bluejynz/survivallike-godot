extends Node2D

@onready var gold_sound = preload("res://addons/sounds/coins.wav")
@onready var audio_player: PackedScene = preload("res://misc/audio_player.tscn")

func _ready():
	$Area2D.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		GameManager.gold_count += (randi_range(3, 5) * 5)
		
		var audio = audio_player.instantiate()
		audio.position = position
		get_tree().root.add_child(audio)
		
		audio.play_audio(gold_sound)
		
		queue_free()
