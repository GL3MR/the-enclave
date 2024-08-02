extends KinematicBody2D

var apparance: String

onready var cell: AnimatedSprite = $apparance

func _ready():
	pass 

func draw(apparance_id: int):
	if apparance_id == -1:
		apparance = "neck"
	else:
		apparance = "body" + str(apparance_id)
	
	$apparance.play(apparance)

func set_cell(curve: bool, flip_h: bool = false, flip_v: bool = false, transpose: int = 0):
	cell.flip_h = flip_h
	cell.flip_v = flip_v
	cell.rotation_degrees = transpose
	
	if curve:
		if apparance.find("_") == -1:
			apparance += "_"
	else:
		if apparance.find("_") != -1:
			apparance = apparance.substr(0, apparance.length() - 1)
	
	$apparance.play(apparance)
