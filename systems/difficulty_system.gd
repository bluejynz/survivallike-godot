extends Node

@export var mob_spawner: MobSpawner
@export var initial_spawn_rate: float = 20
@export var spawn_rate_per_minute: float = 30
@export var wave_duration: float = 20
@export var break_intensity: float = .5

var time_elapsed: float = 0

func _process(delta: float) -> void:
	time_elapsed += delta
	
	var spawn_rate = initial_spawn_rate + spawn_rate_per_minute * (time_elapsed / 60)
	
	var sin_wave = sin((time_elapsed * TAU) / wave_duration)
	var wave_factor = remap(sin_wave, -1, 1, break_intensity, 1)
	spawn_rate *= wave_factor
	print(spawn_rate)
	mob_spawner.mobs_per_minute = spawn_rate
