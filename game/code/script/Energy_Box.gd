extends Area2D

onready var audio_energy: AudioStreamPlayer2D = $energy
onready var apparance: AnimatedSprite = $apparence

var player_in_range = false
var door: Node2D
var charged: bool = false

func _ready():
	pass

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		if Events.batery_count > 0 and !charged:
			audio_energy.play()
			Events.batery_count -= 1
			charged = true
			apparance.play("charged")
			Events.emit_interacted(door)
			if door.get_parent() == self.get_parent().get_node("Room6"):
				Storage.puzzle_complete = true
				Storage.save_game_data()
				get_parent().start_dialogue("sala-principal-puzzle")

func _on_Energy_Box_body_entered(body):
	if body.is_in_group("Door"):
		door = body.get_parent().get_parent()
		Events.emit_door_puzzle(door)
		
		if door.get_parent() == self.get_parent().get_node("Room6"):
			if Storage.puzzle_complete:
				charged = true
				apparance.play("charged")
				Events.emit_interacted(door)
		if door.get_parent() == self.get_parent().get_node("Room5"):
			if Storage.tutorial_complete:
				charged = true
				apparance.play("charged")
				Events.emit_interacted(door)
				
	if body.is_in_group("hero"):
		player_in_range = true


func _on_Energy_Box_body_exited(body):
	if body.is_in_group("hero"):
		player_in_range = false
