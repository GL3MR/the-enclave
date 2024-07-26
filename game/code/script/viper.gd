extends KinematicBody2D

onready var audio_dano: AudioStreamPlayer2D = $dano
onready var audio_morrendo: AudioStreamPlayer2D = $morrendo
onready var audio_ataque: AudioStreamPlayer2D = $ataque
onready var audio_andar: AudioStreamPlayer2D = $andar
var animationAtk = false
var body2 = null
var test = false
var player_chase = false
var player2 = null
var speedv = 120
var inatkzone = false
var stop_distance = 10 
var is_attacking = false
onready var timer := $atkcooldown as Timer
onready var timer2 := $animation as Timer
var life = 6
var damage = 3
var cooldown = true
onready var player_a = get_tree().get_nodes_in_group("hero")
onready var player = player_a[0]
var loot = preload("res://scene/loot.tscn")
var pos = null
var localization: Node2D
var is_defect: bool = false

var in_dialog = false

func _ready():
	Events.connect("player_room_entered", self, "_on_player_room_entered")
	Events.connect("enemy_room_entered", self, "_on_enemy_room_entered")
	Events.connect("in_dialog", self, "_on_in_dialog")
	Events.connect("timeline_ended", self, "on_timeline_ended")

func _on_in_dialog():
	in_dialog = true

func on_timeline_ended():
	in_dialog = false

func _on_player_room_entered(body, room):
	if is_in_room(room):
		attack(body)

func _on_enemy_room_entered(body, room):
	if self == body:
		localization = room 

func is_in_room(room):
	return localization == room

func attack(body):
	player2 = body
	player_chase = true

func _on_Detection_body_entered(body):
	pass
	
func _on_Detection_body_exited(body):
	pass

func _physics_process(delta):
	if life != 0 and is_defect:
		$AnimatedSprite.play("idle")
	elif life != 0 and in_dialog:
		$AnimatedSprite.play("idle")
	elif life != 0 and !animationAtk:
		if player_chase:
			var distance_to_player = player2.position.distance_to(position)
			
			if distance_to_player > stop_distance:
				var direction = (player2.position - position).normalized()
				var velocity = direction * speedv
				move_and_slide(velocity)
				pos = position
				$AnimatedSprite.play("walk")
				if !audio_andar.playing:
					audio_andar.play()
				
				if (player2.position.x - position.x) < 0:
					$AnimatedSprite.flip_h = true
				else:
					$AnimatedSprite.flip_h = false
			elif inatkzone:
				if body2.is_in_group("hero") and cooldown and !body2.invinsible:
					audio_ataque.play()
					$AnimatedSprite.play("atk")
					animationAtk = true
					timer2.start()
					cooldown = false
					timer.start()
			else:
				$AnimatedSprite.play("idle")
		else:
			$AnimatedSprite.play("idle")

func enemy ():
	pass

func _on_Atackarea_body_entered(body):
	if body.is_in_group("hero"):
		inatkzone = true
		body2 = body
		
		
func _on_Atackarea_body_exited(body):
		inatkzone = false
		body2 = null
		
func damage(damage):
	life = max(0, life - damage)
	if life == 0:
		audio_morrendo.play()
		var doors = get_tree().get_nodes_in_group("door") 
		for door in doors:
			if door.nbofmob > 0:
				door.nbofmob -= 1
				if door.nbofmob == 0:
					door.open() 
		$AnimatedSprite.play("death")
	else:
		$effect.play("damage")
		audio_dano.play()



func _on_atkcooldown_timeout():
	cooldown = true
	
func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "death":
		drop_loot()
	if $AnimatedSprite.animation == "atk":
		animationAtk = false
	$AnimatedSprite.play("idle")
		
func drop_loot():
	if !is_defect:
		var nb
		nb = randi()%100
		if nb < 10:
			var newloot = loot.instance()
			get_parent().add_child(newloot)
			newloot.position = pos
	else:
		Events.emit_tutorial_enemy_dead(self.global_position)
		Events.emit_tutorial_player_attacked()
	queue_free() 


func _on_animation_timeout():
	if body2 != null and body2.is_in_group("hero") and life != 0:
		body2.hit(damage)


func _on_effect_animation_finished(anim_name):
	$effect.play("idle")
