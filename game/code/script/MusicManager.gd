extends Node2D

var music_player: AudioStreamPlayer2D
var offset = Vector2(192, 112)

func _ready():
	pass 

func play(music):
	stop_all()
	music_player = get_node(music)
	center_on_camera()
	music_player.play()

func stop_all():
	$Music_Menu.stop()
	$Music_Sala.stop()

func _process(delta):
	center_on_camera()

func center_on_camera():
	if music_player and music_player.playing:
		var camera_position = Camera2d.global_position
		music_player.position = camera_position + offset
