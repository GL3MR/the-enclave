extends Node2D

const MOVE_INTERVAL = .16
const BODY_SCENE = preload("res://scene/dragon_body.tscn")
const HEAD_SCENE = preload("res://scene/dragon_head.tscn")

var snake_body = []
var snake_direction = Vector2(1, 0)
var add_segment = false

func _ready():
	spawn_snake()
	$MoveTimer.start(MOVE_INTERVAL)

func spawn_snake():
	var head = HEAD_SCENE.instance()
	head.position = Vector2(5, 10) * 16
	add_child(head)
	
	var head_dir = relation2head(snake_direction)
	print(head_dir)
	if head_dir == 'right': 
		head.set_cell(true,true,90)
	if head_dir == 'left': 
		head.set_cell(true,false,90)
	if head_dir == 'top': 
		head.set_cell(false,true,0)
	if head_dir == 'bottom': 
		head.set_cell(false,false,0)
	
	snake_body.append({'node': head, 'prev_dir': relation2head(snake_direction)})

	for i in range(2):
		add_body_segment()

func add_body_segment():
	var body = BODY_SCENE.instance()
	var last_segment = snake_body[snake_body.size() - 1]['node']
	body.position = last_segment.position - snake_direction * 16
	
	if snake_body.size() == 1:
		body.draw(-1)
	elif snake_body.size() % 2 == 0:
		body.draw(0)
	else:
		body.draw(1)
	add_child(body)
	
	var body_dir = relation2head(snake_direction)
	if body_dir == 'right': 
		body.set_cell(false,true,true,90)
	if body_dir == 'left': 
		body.set_cell(false,true,false,90)
	if body_dir == 'top': 
		body.set_cell(false,false,true,0)
	if body_dir == 'bottom': 
		body.set_cell(false,false,false,0)
	
	snake_body.append({'node': body, 'prev_dir': snake_body[snake_body.size() - 1]['prev_dir']})

func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_up") and snake_direction != Vector2(0, 1):
		snake_direction = Vector2(0, -1)
	elif event.is_action_pressed("ui_right") and snake_direction != Vector2(-1, 0):
		snake_direction = Vector2(1, 0)
	elif event.is_action_pressed("ui_left") and snake_direction != Vector2(1, 0):
		snake_direction = Vector2(-1, 0)
	elif event.is_action_pressed("ui_down") and snake_direction != Vector2(0, -1):
		snake_direction = Vector2(0, 1)

func move_snake():
	var head = snake_body[0]['node']
	
	var new_position = snake_direction * 16
	var position_ant = head.position
	
	head.position += new_position
	var head_dir = relation2head(snake_direction)
	snake_body[0]['prev_dir'] = head_dir
	if head_dir == 'right': 
		head.set_cell(true,true,90)
	if head_dir == 'left': 
		head.set_cell(true,false,90)
	if head_dir == 'top': 
		head.set_cell(false,true,0)
	if head_dir == 'bottom': 
		head.set_cell(false,false,0)
	
	for i in range(1, snake_body.size()):
		var body = snake_body[i]['node']
		new_position = body.position
		body.position = position_ant
		position_ant = new_position
		
		if i == 1:
			var neck_dir = relation2(position_ant, snake_body[i-1]['node'].position, snake_body[i]['prev_dir'])
			print(neck_dir)
			if neck_dir == 'right': 
				snake_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,true,true,90)
			if neck_dir == 'left': 
				snake_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,true,false,90)
			if neck_dir == 'top': 
				snake_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,false,true,0)
			if neck_dir == 'bottom': 
				snake_body[i]['prev_dir'] = neck_dir
				body.set_cell(false,false,false,0)
			if neck_dir == 'right_top': 
				snake_body[i]['prev_dir'] = 'top'
				body.set_cell(true,false,true,0)
			if neck_dir == 'right_bottom': 
				snake_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,false,false,0)
			if neck_dir == 'top_right': 
				snake_body[i]['prev_dir'] = 'right'
				body.set_cell(true,true,true,90)
			if neck_dir == 'top_left': 
				snake_body[i]['prev_dir'] = 'left'
				body.set_cell(true,true,false,90)
			if neck_dir == 'bottom_right': 
				snake_body[i]['prev_dir'] = 'right'
				body.set_cell(true,false,true,90)
			if neck_dir == 'bottom_left': 
				snake_body[i]['prev_dir'] = 'left'
				body.set_cell(true,false,false,90)
			if neck_dir == 'left_top': 
				snake_body[i]['prev_dir'] = 'top'
				body.set_cell(true,true,true,0)
			if neck_dir == 'left_bottom': 
				snake_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,true,false,0)
		else:
			var body_dir = relation2(position_ant, snake_body[i-1]['node'].position, snake_body[i]['prev_dir'])
			print(body_dir)
			if body_dir == 'right': 
				snake_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,false,0)
			if body_dir == 'left': 
				snake_body[i]['prev_dir'] = body_dir
				body.set_cell(false,true,false,0)
			if body_dir == 'top': 
				snake_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,true,90)
			if body_dir == 'bottom': 
				snake_body[i]['prev_dir'] = body_dir
				body.set_cell(false,false,false,90)
			if body_dir == 'right_top': 
				snake_body[i]['prev_dir'] = 'top'
				body.set_cell(true,false,true,0)
			if body_dir == 'right_bottom': 
				snake_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,false,false,0)
			if body_dir == 'top_right': 
				snake_body[i]['prev_dir'] = 'right'
				body.set_cell(true,true,true,90)
			if body_dir == 'top_left': 
				snake_body[i]['prev_dir'] = 'left'
				body.set_cell(true,true,false,90)
			if body_dir == 'bottom_right': 
				snake_body[i]['prev_dir'] = 'right'
				body.set_cell(true,false,true,90)
			if body_dir == 'bottom_left': 
				snake_body[i]['prev_dir'] = 'left'
				body.set_cell(true,false,false,90)
			if body_dir == 'left_top': 
				snake_body[i]['prev_dir'] = 'top'
				body.set_cell(true,true,true,0)
			if body_dir == 'left_bottom': 
				snake_body[i]['prev_dir'] = 'bottom'
				body.set_cell(true,true,false,0)
		


	if add_segment:
		add_body_segment()
		add_segment = false

func _on_MoveTimer_timeout():
	add_body_segment()
	move_snake()

func reset_snake():
	for segment in snake_body:
		segment.queue_free()
	snake_body.clear()


func relation2(first_block:Vector2,second_block:Vector2, prev_dir:String):
	var block_relation = first_block - second_block
	if abs(block_relation.x) != 32 and abs(block_relation.y) != 32:
		print(block_relation)
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
