extends Node2D

onready var musica_ambiente: AudioStreamPlayer2D = $ambiente
onready var player: Node2D = $Player

func _ready():
	set_process(true) 

func _process(delta):
	musica_ambiente.global_position = player.global_position
