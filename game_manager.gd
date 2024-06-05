extends Node

signal gold_collected
signal game_over
signal mob_killed
signal level_up

var is_os_mobile: bool
@onready var joystick: VirtualJoystick = get_node("/root/MainScene/GameUI/VirtualJoystick")

var player: Player
var player_position: Vector2

var gold_count: int = 0
var elapsed_time: float = 0
var elapsed_time_text: String
var monsters_slayed: int = 0

var is_game_paused: bool = false
var is_game_over: bool = false
var is_game_muted: bool = false

func _ready():
	is_os_mobile = OS.get_model_name() != "GenericDevice"
	config_mobile()

func _process(delta):
	if is_game_paused: return
	elapsed_time += delta
	var elapsed_time_in_seconds: int = floori(GameManager.elapsed_time)
	var seconds: int = elapsed_time_in_seconds % 60
	var minutes: int = elapsed_time_in_seconds / 60
	elapsed_time_text = "%02d:%02d" % [minutes, seconds]
	if Input.is_action_just_pressed("toggle_mute"):
		toggle_mute()

func toggle_mute():
	is_game_muted = not is_game_muted
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), is_game_muted)
	if OS.has_feature("persistant_storage"):
		ProjectSettings.set_setting("application/game_is_muted", is_game_muted)

func end_game():
	if is_game_over: return
	is_game_over = true
	game_over.emit()

func reset():
	player = null
	player_position = Vector2.ZERO
	elapsed_time = 0
	elapsed_time_text = ""
	gold_count = 0
	monsters_slayed = 0
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)

func config_mobile():
	if is_os_mobile:
		ProjectSettings.set_setting("input_devices/pointing/emulate_mouse_from_touch", true)
	else:
		ProjectSettings.set_setting("input_devices/pointing/emulate_mouse_from_touch", false)
		# next line deletes joystick when playing on device that's not mobile
		#joystick.queue_free()

func toggle_pause():
	is_game_paused = not is_game_paused
