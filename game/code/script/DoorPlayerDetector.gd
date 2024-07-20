extends Area2D

onready var position_2d: Position2D = $Position2D


func _on_DoorPlayerDetector_body_entered(body):
	print(body)
	body.global_position = position_2d.global_position
