extends KinematicBody2D
export(PackedScene) var projectile_scene

var life = 4
var damage = 3
var projectile_cooldown = 1
var player = null
var localization: Node2D
var can_shoot = true
var player_side = 1

func _ready():
	Events.connect("player_room_entered", self, "_on_player_room_entered")
	Events.connect("enemy_room_entered", self, "_on_enemy_room_entered")
	idle()

func _process(delta):
	if player: player_side = player.position.x - position.x
	if player_side < 0:
		$SpirkAnimation.flip_h = true
	else:
		$SpirkAnimation.flip_h = false
	if can_shoot:
		attack()

func _on_player_room_entered(body, room):
	print("Spirk: _on_player_room_entered")
	if is_in_room(room):
		player = body

func _on_enemy_room_entered(body, room):
	print("Spirk: _on_enemy_room_entered")
	if self == body:
		localization = room 

# Despawn quando muda de sala
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func is_in_room(room):
	return localization == room

# Setup 
func idle():
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "idle"
	$SpirkAnimation.play()

# Gerar e disparar projetil
func attack():
	can_shoot = false
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "attack"
	$SpirkAnimation.play()
	$TimerAttack.start()
	
	
# Quando o player chegar perto, ele deve fugir
func walk():
	pass

# Animação de morte e deleção do objeto
func die():
	print("Die")
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "dead"
	$SpirkAnimation.play()
	$TimerDeath.start()


func damage(amount):
	life -= amount
	if life <= 0:
		die()


######################## TIMERS ##########################

# timer antes de fazer o despawn
func _on_TimerDeath_timeout():
	queue_free()

# Cria e dispara um projétil e ativa um tempo de cooldown
func _on_TimerAttack_timeout():
	var direction_vector = player.position - position
	direction_vector.y += 8 # corrige trajetoria da bola pra mirar no meio do sprite
	var ball = projectile_scene.instance()
	var angle = direction_vector.angle() - PI/2
	ball.linear_velocity = Vector2(0,200).rotated(angle)
	add_child(ball)
	$TimerCooldown.start()
	idle()

# Quando acabar o spirk pode atacar novamente
func _on_TimerCooldown_timeout():
	can_shoot = true
