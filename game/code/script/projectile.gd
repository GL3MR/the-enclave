extends KinematicBody2D

var allie_ = false 
var damage_ = 1
var speed_ = 100 
var tde_life = 1
var dir = Vector2(0, 0)
var id 
var timer_life 

func _ready():
	timer_life = Timer.new()
	timer_life.set_wait_time(tde_life)
	timer_life.connect("timeout", self, "_on_timerlife_timeout")
	add_child(timer_life)
	timer_life.start() 

func init(allie_, damage_, speed_, tde_life, dimension, apparence, dir, pos, rot, flip):
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
		$area/col.position.x += 18
	elif apparence == 1:
		$area/col.position.x +=21
	elif apparence == 2:
		$area/col.position.x +=16
#	if(flip):
#		 self.position.x +=  6
#	else:
#		self.position.x -= 6
	if rot:
		rotation_degrees = angle
	$apparence.play("weapon" + str(apparence))
	var weapon_node = get_node("weapon_" + str(apparence))
	weapon_node.play()
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
	if body.is_in_group("boss") and allie_ and body.life > 0:
		body.life -= 1 
		if id == 1:
			weapon_1_blust()
	if body.is_in_group("switch") and (id == 0 or id == 1 or id == 5):
		body.open() 
	if body.is_in_group("lampe") and (id == 2):
		body.lightUp() 
	if body.is_in_group("mob") and allie_ and body.life > 0:
		body.damage(damage_) 
		if id == 1:
			weapon_1_blust()
	if body.is_in_group("hero") and not allie_:
		body.hit(damage_) 

func weapon_1_blust():
	speed_ = 0 
	$apparence.play("weapon1-blust")
	yield($apparence, "animation_finished")
	queue_free()
