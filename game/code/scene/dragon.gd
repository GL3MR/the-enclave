extends Node2D

const MOVE_INTERVAL = .16
const SPEED = 16
const BODY_SCENE = preload("res://scene/dragon_body.tscn")
const HEAD_SCENE = preload("res://scene/dragon_head.tscn")

var player = null
var position_init = null
var direction = Vector2()
var direction_init = Vector2()

var dragon_body = []

func initialize(player_, position_init_, flip):
	player = player_
	position_init = position_init_

	if !flip:
		direction_init = Vector2(1, 0)
	else:
		direction_init = Vector2(-1, 0)
		position_init += Vector2(-64, 0)

	spawn_dragon()

func _ready():
	
	Events.connect("dragon_catch_player", self, "on_dragon_catch_player")
	Events.connect("dragon_catch_boss", self, "on_dragon_catch_boss")

func on_dragon_catch_player(body):
	Events.emit_flash_screen(Color(0.803922, 0.262745, 0.262745))
	queue_free()

func on_dragon_catch_boss(body):
	Events.emit_flash_screen(Color(0.803922, 0.262745, 0.262745))
	queue_free()

func spawn_dragon():
	var head = HEAD_SCENE.instance()
	head.position = position_init 
	add_child(head)
	
	var head_dir = relation2head(direction_init)
	if head_dir == 'right': 
		head.set_cell(true,true,90)
	if head_dir == 'left': 
		head.set_cell(true,false,90)
	
	dragon_body.append({'node': head, 'prev_dir': head_dir})

	for i in range(2):
		add_body_segment()
		
	$MoveTimer.start(MOVE_INTERVAL)

func add_body_segment():
	var body = BODY_SCENE.instance()
	var last_segment = dragon_body[dragon_body.size() - 1]['node']
	body.position = last_segment.position - direction_init 
	
	if dragon_body.size() == 1:
		body.draw(-1)
	elif dragon_body.size() % 2 == 0:
		body.draw(0)
	else:
		body.draw(1)
	add_child(body)
	
	var body_dir = relation2head(direction_init)
	if body_dir == 'right': 
		body.set_cell(false,false,false,0)
	if body_dir == 'left': 
		body.set_cell(false,true,false,0)
	
	dragon_body.append({'node': body, 'prev_dir': body_dir})

func _process(delta):
	pass

func move_snake():
	var head = dragon_body[0]['node']
	
	var new_position = position + direction * SPEED
	var position_ant = head.position
	
	head.position += new_position
	var head_dir = relation2head(direction)
	dragon_body[0]['prev_dir'] = head_dir
	if head_dir == 'right': 
		head.set_cell(true,true,90)
	if head_dir == 'left': 
		head.set_cell(true,false,90)
	if head_dir == 'top': 
		head.set_cell(false,true,0)
	if head_dir == 'bottom': 
		head.set_cell(false,false,0)
	
	for i in range(1, dragon_body.size()):
		var body = dragon_body[i]['node']
		new_position = body.position
		body.position = position_ant
		position_ant = new_position
		
		if i == 1:
			var neck_dir = relation2(position_ant, dragon_body[i-1]['node'].position, dragon_body[i]['prev_dir'])
			if neck_dir == 'right': 
				dragon_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,true,true,90)
			if neck_dir == 'left': 
				dragon_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,true,false,90)
			if neck_dir == 'top': 
				dragon_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,false,true,0)
			if neck_dir == 'bottom': 
				dragon_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,false,false,0)
			if neck_dir == 'right_top': 
				dragon_body[i]['prev_dir'] = 'top'
				body.set_cell(true,false,true,0)
			if neck_dir == 'right_bottom': 
				dragon_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,false,false,0)
			if neck_dir == 'top_right': 
				dragon_body[i]['prev_dir'] = 'right'
				body.set_cell(true,true,true,90)
			if neck_dir == 'top_left': 
				dragon_body[i]['prev_dir'] = 'left'
				body.set_cell(true,true,false,90)
			if neck_dir == 'bottom_right': 
				dragon_body[i]['prev_dir'] = 'right'
				body.set_cell(true,false,true,90)
			if neck_dir == 'bottom_left': 
				dragon_body[i]['prev_dir'] = 'left'
				body.set_cell(true,false,false,90)
			if neck_dir == 'left_top': 
				dragon_body[i]['prev_dir'] = 'top'
				body.set_cell(true,true,true,0)
			if neck_dir == 'left_bottom': 
				dragon_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,true,false,0)
		else:
			var body_dir = relation2(position_ant, dragon_body[i-1]['node'].position, dragon_body[i]['prev_dir'])
			if body_dir == 'right': 
				dragon_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,false,0)
			if body_dir == 'left': 
				dragon_body[i]['prev_dir'] = body_dir
				body.set_cell(false,true,false,0)
			if body_dir == 'top': 
				dragon_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,true,90)
			if body_dir == 'bottom': 
				dragon_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,false,90)
			if body_dir == 'right_top': 
				dragon_body[i]['prev_dir'] = 'top'
				body.set_cell(true,false,true,0)
			if body_dir == 'right_bottom': 
				dragon_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,false,false,0)
			if body_dir == 'top_right': 
				dragon_body[i]['prev_dir'] = 'right'
				body.set_cell(true,true,true,90)
			if body_dir == 'top_left': 
				dragon_body[i]['prev_dir'] = 'left'
				body.set_cell(true,true,false,90)
			if body_dir == 'bottom_right': 
				dragon_body[i]['prev_dir'] = 'right'
				body.set_cell(true,false,true,90)
			if body_dir == 'bottom_left': 
				dragon_body[i]['prev_dir'] = 'left'
				body.set_cell(true,false,false,90)
			if body_dir == 'left_top': 
				dragon_body[i]['prev_dir'] = 'top'
				body.set_cell(true,true,true,0)
			if body_dir == 'left_bottom': 
				dragon_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,true,false,0)

func _on_MoveTimer_timeout():
	if player:
		add_body_segment()
		update_direction()
		move_snake()

func update_direction():
	var player_pos = player.global_position
	var delta = player_pos - dragon_body[0]['node'].global_position
	
	if abs(delta.x) > abs(delta.y):
		if delta.x > 0 and dragon_body[0]['prev_dir'] == 'left':
			if delta.y > 0:
				direction = Vector2(0, 1)  # Baixo
			else:
				direction = Vector2(0, -1)  # Cima
		elif delta.x > 0:
			direction = Vector2(1, 0)  # Direita
		else:
			direction = Vector2(-1, 0)  # Esquerda
	else:
		if delta.y > 0 and dragon_body[0]['prev_dir'] == 'top':
			if delta.x > 0:
				direction = Vector2(1, 0)  # Direita
			else:
				direction = Vector2(-1, 0)  # Esquerda
		elif delta.y > 0:
			direction = Vector2(0, 1)  # Baixo
		else:
			direction = Vector2(0, -1)  # Cima


func relation2(first_block:Vector2,second_block:Vector2, prev_dir:String):
	var block_relation = first_block - second_block
	if block_relation == Vector2(32,0): return 'left'
	if block_relation == Vector2(-32,0): return 'right'
	if block_relation == Vector2(0,-32): return 'bottom'
	if block_relation == Vector2(0,32): return 'top'
	if prev_dir == 'right' and block_relation == Vector2(-16,16): return 'right_top'
	if prev_dir == 'right' and block_relation == Vector2(-16,-16): return 'right_bottom'
	if prev_dir == 'top' and block_relation == Vector2(-16,16): return 'top_right'
	if prev_dir == 'top' and block_relation == Vector2(16,16): return 'top_left'
	if prev_dir == 'bottom' and block_relation == Vector2(-16,-16): return 'bottom_right'
	if prev_dir == 'bottom' and block_relation == Vector2(16,-16): return 'bottom_left'
	if prev_dir == 'left' and block_relation == Vector2(16,16): return 'left_top'
	if prev_dir == 'left' and block_relation == Vector2(16,-16): return 'left_bottom'

func relation2head(block_relation:Vector2):
	if block_relation == Vector2(-1,0): return 'left'
	if block_relation == Vector2(1,0): return 'right'
	if block_relation == Vector2(0,1): return 'bottom'
	if block_relation == Vector2(0,-1): return 'top'
