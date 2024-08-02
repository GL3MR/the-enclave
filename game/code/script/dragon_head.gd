extends KinematicBody2D

onready var cell: AnimatedSprite = $apparance

func _ready():
	pass

func set_cell(flip_h: bool = false, flip_v: bool = false, transpose: int = 0):
	print(cell)
	cell.flip_h = flip_h
	cell.flip_v = flip_v
	cell.rotation_degrees = transpose
