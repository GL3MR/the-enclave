extends KinematicBody2D  # Classe base para corpos físicos que se movem e colidem

var life = 4  # Vida do inimigo
var damage = 1  # Dano causado pelo inimigo

onready var player_a = get_tree().get_nodes_in_group("hero")  # Obtém todos os nós no grupo "hero"
onready var player = player_a[0]  # Pega o primeiro nó do grupo "hero"

var player_pos = Vector2(0, 0)  # Posição do jogador
var mob_pos = Vector2(0, 0)  # Posição do inimigo

enum direction {up, down, left, right }    # Direções de movimento
var random  # Variável para direção aleatória
var speed = 100  # Velocidade de movimento do inimigo
var timer_move  # Temporizador para movimento
var can_move = false  # Controle de movimento
var timer_shoot  # Temporizador para atirar
var dir = Vector2(1, 0)  # Direção inicial do inimigo

func _ready():
	move()  # Inicia o movimento
	shoot()  # Inicia o disparo de projéteis

func shoot():
	timer_shoot = Timer.new()
	timer_shoot.set_wait_time(1)
	timer_shoot.connect("timeout", self, "_on_timershoot_timeout")
	add_child(timer_shoot)
	timer_shoot.start()
	
	var pack_proj = preload("res://scene/projectile.tscn")  # Pré-carrega a cena do projétil
	var inst_proj = pack_proj.instance()  # Instancia o projétil
	inst_proj.init(false, 1, 50, 2, Vector2(4, 4), 4, dir, position, false)  # Inicializa o projétil com parâmetros
	
	get_parent().call_deferred("add_child", inst_proj)  # Adiciona o projétil ao nó pai

func _on_timershoot_timeout():
	timer_shoot.queue_free()  # Remove o temporizador antigo
	shoot()  # Chama a função de disparo novamente

func _physics_process(delta):
	player_pos = player.return_position()  # Atualiza a posição do jogador
	mob_pos = self.position  # Atualiza a posição do inimigo
	    
	if can_move:
		random = randi() % 5 + 1  # Gera uma direção aleatória
		move()  # Chama a função de movimento
	    
	if random == 1:
		move_and_slide(Vector2(speed, 0))  # Move para a direita
		direction.right
		rotation_degrees = 90
		dir = Vector2(1, 0)
	elif random == 2:
		move_and_slide(Vector2(-speed, 0))  # Move para a esquerda
		direction.left
		rotation_degrees = 270
		dir = Vector2(-1, 0)
	elif random == 3:
		move_and_slide(Vector2(0, speed))  # Move para baixo
		direction.down
		rotation_degrees = 180
		dir = Vector2(0, 1)
	elif random == 4:
		move_and_slide(Vector2(0, -speed))  # Move para cima
		direction.up
		rotation_degrees = 0
		dir = Vector2(0, -1)

func damage(damage):
	life = max(0, life - damage)  # Reduz a vida do inimigo
	$anim.play("degat")  # Toca a animação de dano
    
	if life == 0:
		var doors = get_tree().get_nodes_in_group("door")  # Obtém todos os nós no grupo "door"
		for door in doors:
			if door.nbofmob > 0:
				door.nbofmob -= 1
				if door.nbofmob == 0:
					door.open()  # Abre a porta se todos os inimigos forem eliminados
		queue_free()  # Remove o inimigo

func move():
	can_move = false
	timer_move = Timer.new()
	timer_move.set_wait_time(1)
	timer_move.connect("timeout", self, "_on_timermove_timeout")
	add_child(timer_move)
	timer_move.start()

func _on_timermove_timeout():
	timer_move.queue_free()  # Remove o temporizador de movimento
	can_move = true  # Permite o movimento

func _on_Area2D_body_entered(body):
	if body.is_in_group("hero"):
		body.hit(1)  # Causa dano ao jogador quando o jogador entra na área do inimigo
