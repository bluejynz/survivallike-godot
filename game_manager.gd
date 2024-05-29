extends Node

signal gold_collected
signal game_over

var player: Player
var player_position: Vector2

var gold_count: int = 0
var elapsed_time: float = 0
var is_game_over: bool = false

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	elapsed_time = 0
	gold_count = 0
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
