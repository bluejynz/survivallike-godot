class_name Highscore
extends Node

const save_highscores_path: String = "res://systems/highscore/highscores.json"

func _ready():
	pass

func check_is_highscore(score: int) -> bool:
	var highscores: Dictionary = load_highscores()
	
	for highscore in highscores:
		if score > highscores[highscore]["score"]:
			return true
	
	return false

func load_highscores() -> Dictionary:
	var highscores_file = FileAccess.open(save_highscores_path, FileAccess.READ)
	
	var json: JSON = JSON.new()
	
	var error = json.parse(highscores_file.get_as_text())
	if not error == OK:
		return {}
	
	var highscores: Dictionary = json.data
	highscores_file.close()
	
	return highscores

func save_highscore(name: String, score: int):
	var highscores: Dictionary = load_highscores()
	var highscores_file = FileAccess.open(save_highscores_path, FileAccess.WRITE)
	
	var shifted_highscores: Dictionary
	var index: String = ""
	for highscore in highscores:
		if score > highscores[highscore]["score"]:
			if index == "":
				index = highscore
				shifted_highscores = shift_highscores(int(index), highscores)
	
	if not index == "" and not check_if_highscore_exists(highscores, name, score):
		highscores = merge_highscores(highscores, shifted_highscores)
		highscores[index]["name"] = name
		highscores[index]["score"] = score
	
	highscores_file.store_string(JSON.stringify(highscores))
	highscores_file.close()

func shift_highscores(index: int, highscores: Dictionary) -> Dictionary:
	var shifted_highscores: Dictionary = {}
	for i in range(index, 8):
		var key: String = str(int(i) + 1)
		shifted_highscores[key] = { 
			"name": highscores[str(i)]["name"], 
			"score": highscores[str(i)]["score"]
			}
	
	return shifted_highscores

func merge_highscores(highscores: Dictionary, shifted_highscores: Dictionary) -> Dictionary:
	for shifted in shifted_highscores:
		highscores[shifted]["name"] = shifted_highscores[shifted]["name"]
		highscores[shifted]["score"] = shifted_highscores[shifted]["score"]
	
	return highscores

func check_if_highscore_exists(highscores: Dictionary, name: String, score: int) -> bool:
	for hs in highscores:
		if highscores[hs]["name"] == name and highscores[hs]["score"] == score:
			return true
	
	return false
