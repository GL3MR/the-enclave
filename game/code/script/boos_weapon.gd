extends KinematicBody2D

var allie_ = false 
var damage_ = 1
var speed_ = 100 
var tde_life = 1
var dir = Vector2(0, 0)
var id 
var timer_life 
var timestamp = 0.3

func _ready():
	timer_life = Timer.new()
	timer_life.set_wait_time(tde_life)
	timer_life.connect("timeout", self, "_on_timerlife_timeout")
	add_child(timer_life)
	timer_life.start() 
	
	var timer = Timer.new()
	timer.wait_time = timestamp
	add_child(timer)
	timer.connect("timeout", self, "_on_timer_timeout")
	timer.start()

func init(allie_, damage_, speed_, tde_life, dimension, apparence, dir, pos, rot, flip, timestamp_):
	timestamp = timestamp_
	print(timestamp)
	
	$area/col.disabled = true
	self.allie_ = allie_ 
	self.damage_ = damage_ 
	self.speed_ = speed_ 
	self.tde_life = tde_life
	self.dir = dir
	self.id = apparence
	var angle 
	angle =  rad2deg(atan2(dir.y, dir.x))
	self.position = pos
	
#	self.position.y +=  9
	if apparence == 0:
		$area/col.position.x += 32
	elif apparence == 1:
		$area/col.position.x +=42
		$area/col.position.y -=8
		$area/col.position.x +=16
#	elif apparence == 2:
#		$area/col.position.x +=16
#	if(flip):
#		 self.position.x +=  6
#	else:
#		self.position.x -= 6
	if rot:
		rotation_degrees = angle
	$apparence.play("atk" + str(apparence))
#	var weapon_node = get_node("atk" + str(apparence))
#	weapon_node.play()
	$area/col.shape.extents = dimension / 2

func _physics_process(delta):
	move_and_slide(dir * speed_) 

func _on_timerlife_timeout():
	destroy()  

func destroy():
	queue_free() 

func _on_area_body_entered(body):
	if body is StaticBody2D:
		if id == 1:
			weapon_1_blust()
	if body is TileMap:
		if id == 1:
			weapon_1_blust()
	if body.is_in_group("hero") and !body.invinsible:
		body.hit(damage_) 
		if id == 1:
			weapon_1_blust()

func weapon_1_blust():
	speed_ = 0 
	$apparence.play("atk1-blust")
	yield($apparence, "animation_finished")
	queue_free()

func _on_timer_timeout():
	$area/col.disabled = false
