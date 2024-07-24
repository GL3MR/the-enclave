extends KinematicBody2D
export(PackedScene) var projectile_scene

var life = 4
var damage = 3
var projectile_cooldown = 1
var player
var localization: Node2D
var can_shoot = true


func _ready():
	Events.connect("player_room_entered", self, "_on_player_room_entered")
	Events.connect("enemy_room_entered", self, "_on_enemy_room_entered")
	idle()

func _process(delta):
	if can_shoot:
		attack()

func _on_player_room_entered(body, room):

	if is_in_room(room):
		player = body

# Despawn quando muda de sala
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func is_in_room(room):
	return localization == room
func _on_enemy_room_entered(body, room):
	if self == body:
		localization = room 

# Setup 
func idle():
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "idle"
	$SpirkAnimation.play()

# Gerar e disparar projetil
func attack():
	$SpirkAnimation.stop()
	$SpirkAnimation.animation = "attack"
	$SpirkAnimation.play()
	$TimerAttack.start()
	
	
# Quando o player chegar perto, ele deve fugir
func walk():
	pass

# Animação de morte e deleção do objeto
func die():
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
	var ball = projectile_scene
	ball.position = self.position
	ball.linear_velocity(Vector2(300,0))
	add_child(ball)
	can_shoot = false
	$TimerCooldown.start()

# Quando acabar o spirk pode atacar novamente
func _on_TimerCooldown_timeout():
	can_shoot = true
