extends KinematicBody2D

onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]

var player_pos = Vector2(0, 0)
var life = 10

func _ready():
	pass

func _process(delta):
	player_pos = player.returnPosition()

func _attack_meteore():
	$AnimatedSprite.play("attack_meteore")

func _take_dammage():
	life -= 1
