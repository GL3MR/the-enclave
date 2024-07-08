extends KinematicBody2D

onready var animation_player = $animation
var can_pick = true
var target_rotation = 0
var target_rotation_current = 0

# Variáveis de estado do jogador
var life = 3  # Vida atual do jogador
var timer = null  # Timer para várias funcionalidades
var speed = 100  # Velocidade de movimento do jogador
var dash_speed = 300  # Velocidade de movimento ao dar dash
var invinsible = false  # Flag para estado de invulnerabilidade

# Estatísticas das armas
var stat_weapon = [
{"damage_": 2, "speed_": 0, "lifespan_": 0.4, "dimension_": Vector2(15, 4), "rotate_": true}, 
{"damage_": 1, "speed_": 400, "lifespan_": 1, "dimension_": Vector2(4, 1), "rotate_": true}, 
{"damage_": 1, "speed_": 0, "lifespan_": 1, "dimension_": Vector2(8, 8), "rotate_": true}, 
{"damage_": 0, "speed_": 0, "lifespan_": 2, "dimension_": Vector2(10, 10), "rotate_": false}
]

# Identificadores de arma
var id_weapon = 0  # ID da arma atual
var id_weapon_number = global.id_weapon_number  # ID máximo de armas disponíveis
var action = 1  # ID real da arma

# URLs das imagens das armas
var path_weapon = [
"res://art/menu/sabre_hud.png", 
"res://art/menu/blaster_hud.png", 
"res://art/menu/plasma_hud.png",
"res://art/menu/mine_hud.png"
]

export var position_player = Vector2(0, 0)  # Posição do jogador
var direction = Vector2(0, -1)  # Direção do movimento do jogador
var true_direction = Vector2(0, 0)  # Direção real do movimento
var dashing = false  # Flag para estado de dash
var atacking = false  # Flag para estado de ataque

# Timers para dash, ataque e invulnerabilidade
var timer_dash
var timer_att
var timer_invul

# Função chamada quando o nó está pronto
func _ready():
	$hud/bar.value = life * 16  # Inicializa a barra de vida no HUD

# Função chamada a cada frame para processar a física
func _physics_process(delta):
    if not dashing and not atacking:
        # Processamento de movimento baseado na entrada do jogador
        if Input.is_action_pressed("move_right") and true_direction.y == 0:
            if Input.is_action_pressed("move_down"):
                move_and_slide(Vector2(speed * sqrt(2) / 2, speed * sqrt(2) / 2))
            elif Input.is_action_pressed("move_up"):
                move_and_slide(Vector2(speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
            else:
                move_and_slide(Vector2(speed, 0))
                true_direction.x = 1
            $AnimatedSprite.play("move2")
        elif Input.is_action_pressed("move_left") and true_direction.y == 0:
            if Input.is_action_pressed("move_down"):
                move_and_slide(Vector2(-speed * sqrt(2) / 2, speed * sqrt(2) / 2))
            elif Input.is_action_pressed("move_up"):
                move_and_slide(Vector2(-speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
            else:
                move_and_slide(Vector2(-speed, 0))
                true_direction.x = -1
            $AnimatedSprite.play("move3")
        elif Input.is_action_pressed("move_down") and true_direction.x == 0:
            if Input.is_action_pressed("move_left"):
                move_and_slide(Vector2(-speed * sqrt(2) / 2, speed * sqrt(2) / 2))
            elif Input.is_action_pressed("move_right"):
                move_and_slide(Vector2(speed * sqrt(2) / 2, speed * sqrt(2) / 2))
            else:
                move_and_slide(Vector2(0, speed))
                true_direction.y = 1
            $AnimatedSprite.play("move0")
        elif Input.is_action_pressed("move_up") and true_direction.x == 0:
            if Input.is_action_pressed("move_left"):
                move_and_slide(Vector2(-speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
            elif Input.is_action_pressed("move_right"):
                move_and_slide(Vector2(speed * sqrt(2) / 2, -speed * sqrt(2) / 2))
            else:
                move_and_slide(Vector2(0, -speed))
                true_direction.y = -1
            $AnimatedSprite.play("move1")
        else:
            true_direction = Vector2(0, 0)
            if direction.y == 1:
                $AnimatedSprite.play("wait0")
            elif direction.y == -1:
                $AnimatedSprite.play("wait1")
            if direction.x == 1:
                $AnimatedSprite.play("wait2")
            elif direction.x == -1:
                $AnimatedSprite.play("wait3")
        if true_direction != Vector2(0, 0):
            direction = true_direction
        if Input.is_action_just_pressed("switch"):
            switch()
        if Input.is_action_just_pressed("Special"):
            if action == 1:
                dash()
        if Input.is_action_just_pressed("attaque") and not has_node("InGameMenu"):
            attack()
    elif dashing:
        move_and_slide(direction * dash_speed)

# Função para alternar entre as armas
func switch():
	id_weapon = (id_weapon + 1) % id_weapon_number
	if not has_node("InGameMenu"):
		var pack_menu = preload("res://scene/item_menu.tscn")
		var inst_menu = pack_menu.instance()
		add_child(inst_menu)
		inst_menu.switch(id_weapon)
	else:
		$InGameMenu.switch(id_weapon)
	apparence_hud()

# Função para atualizar a aparência do HUD
func apparence_hud():
	$hud/weapon_switch.set_texture(load(path_weapon[id_weapon]))

# Função para realizar o dash
func dash():
	dashing = true
	timer_dash = Timer.new()
	timer_dash.set_wait_time(0.2)
	timer_dash.connect("timeout", self, "_on_timerdash_timeout")
	add_child(timer_dash)
	timer_dash.start()

# Função para realizar um ataque
func attack():
	atacking = true
	timer_att = Timer.new()
	timer_att.set_wait_time(0.4)
	timer_att.connect("timeout", self, "_on_timeratt_timeout")
	add_child(timer_att)
	timer_att.start()
	var pack_proj = preload("res://scene/projectile.tscn")
	var inst_proj = pack_proj.instance()
	var stat = stat_weapon[id_weapon]
	inst_proj.init(true, stat.damage_, stat.speed_, stat.lifespan_, stat.dimension_, id_weapon, direction, position, stat.rotate_)
	get_parent().add_child(inst_proj)

# Função chamada quando o jogador é atingido
func hit(dmg):
	if not invinsible:
		invinsible = true
		life = max(0, life - dmg)
		timer_invul = Timer.new()
		timer_invul.set_wait_time(1.5)
		timer_invul.connect("timeout", self, "_on_timerinvul_timeout")
		add_child(timer_invul)
		timer_invul.start()
		$anim.play("invul")
		$hud/bar.value = life * 16
		if life == 0:
			get_tree().change_scene("res://scene/game_over.tscn")

# Função chamada quando o timer de ataque expira
func _on_timeratt_timeout():
	timer_att.queue_free()
	atacking = false

# Função chamada quando o timer de dash expira
func _on_timerdash_timeout():
	timer_dash.queue_free()
	dashing = false

# Função chamada quando o timer de invulnerabilidade expira
func _on_timerinvul_timeout():
	invinsible = false
	timer_invul.queue_free()
	$anim.play("rien")

# Função para retornar a posição do jogador
func return_position():
	return self.position

func anim_switch(animation):
	var new_anim = str(animation)
	if animation_player.current_animation != new_anim:
		animation_player.play(new_anim)
