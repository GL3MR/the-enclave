extends KinematicBody2D
export(PackedScene) var projectile_scene

var life = 4
var damage = 3
var projectile_cooldown = 1
var player = null
var localization: Node2D
var can_shoot = true
var player_side = 1
var fleeing = false
var speed
var player_distance

var loot = preload("res://scene/loot.tscn")

func _ready():
	speed = 170
	Events.connect("player_room_entered", self, "_on_player_room_entered")
	Events.connect("enemy_room_entered", self, "_on_enemy_room_entered")
	idle()

func _physics_process(delta):
	if player:
		player_side = player.position.x - position.x
	if !fleeing:
		if player_side < 0:
			$SpirkAnimation.flip_h = true
		else:
			$SpirkAnimation.flip_h = false
	if can_shoot and not fleeing and life != 0:
		attack()
	elif fleeing and life != 0:
		walk(delta)

func _on_player_room_entered(body, room):
	if is_in_room(room):
		player = body

func _on_enemy_room_entered(body, room):
	if self == body:
		localization = room 

# Despawn quando muda de sala
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func is_in_room(room):
	return localization == room

# Setup 
func idle():
	$andar.stop()
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "idle"
	$SpirkAnimation.play()

# Gerar e disparar projetil
func attack():
	$ataque.play()
	can_shoot = false
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "attack"
	
	$SpirkAnimation.play()
	if $TimerAttack.is_stopped():
		$TimerAttack.start()
	
	
# Quando o player chegar perto, ele deve fugir
func walk(delta):
	var direction = self.position - player.position
	move_and_slide(direction.normalized() * speed)
	
# Animação de morte e deleção do objeto
func die():
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "dead"
	$SpirkAnimation.play()
	$morrendo.play()
#	$TimerDeath.start()
	yield($SpirkAnimation, "animation_finished")
	drop()


func damage(amount):
	life = max(0, life - amount)
	if life <= 0:
		die()
	else:
		$effect.play("damage")
		$dano.play()


######################## TIMERS ##########################

# timer antes de fazer o despawn
func _on_TimerDeath_timeout():
	queue_free()

# Cria e dispara um projétil e ativa um tempo de cooldown
func _on_TimerAttack_timeout():
	if life > 0 and $SpirkAnimation.animation == "attack":
		var direction_vector = player.position - position
		direction_vector.y += 8 # corrige trajetoria da bola pra mirar no meio do sprite
		var ball = projectile_scene.instance()
		var angle = direction_vector.angle()
		ball.linear_velocity = Vector2(400,0).rotated(angle)
		add_child(ball)
		$TimerCooldown.start()
		idle()

# Quando acabar o spirk pode atacar novamente
func _on_TimerCooldown_timeout():
	can_shoot = true


func _on_NearArea_body_entered(body):
	if life != 0:
		$SpirkAnimation.stop()
		$SpirkAnimation.animation = "walk"
		if !$andar.playing:
			$andar.play()
		$SpirkAnimation.play()
		if body == player:
			fleeing = true
			$SpirkAnimation.flip_h = not $SpirkAnimation.flip_h


func _on_FarArea_body_exited(body):
	if body == player:
		fleeing = false
		if not can_shoot and life != 0: 
			can_shoot = true
			attack()
			
func drop():
	var nb
	nb = randi()%100
	if nb < 10:
		var newloot = loot.instance()
		get_parent().add_child(newloot)
		newloot.position = position
	queue_free() 


func _on_effect_animation_finished(anim_name):
	$effect.play("idle")
