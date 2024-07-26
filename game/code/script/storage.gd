extends Node

export var in_game: bool = false
export var in_challenge: bool = false
export var boss_defeated: bool = false
export var battery_localization: NodePath
export var puzzle_complete: bool = false
export var tutorial_complete: bool = false

func _ready():
	load_game_data()

func load_game_data():
	var file = File.new()
	if file.file_exists("user://save_state.dat"):
		file.open("user://save_state.dat", File.READ)
		in_game = file.get_var()
		in_challenge = file.get_var()
		boss_defeated = file.get_var()
		battery_localization = file.get_var()
		puzzle_complete = file.get_var()
		tutorial_complete = file.get_var()
		file.close()
		print("Storage carregado")
	else:
		save_game_data()

func save_game_data():
	var file = File.new()
	file.open("user://save_state.dat", File.WRITE)
	file.store_var(in_game)
	file.store_var(in_challenge)
	file.store_var(boss_defeated)
	file.store_var(battery_localization)
	file.store_var(puzzle_complete)
	file.store_var(tutorial_complete)
	file.close()
	print("Storage salvo")
	
