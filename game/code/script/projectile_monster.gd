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

func init(allie_, damage_, speed_, tde_life, dimension, apparence, dir, pos, rot):
	z_index = -1
	self.allie_ = allie_
	self.damage_ = damage_
	self.speed_ = speed_
	self.tde_life = tde_life 
	self.dir = dir 
	self.id = apparence 
	var angle
	angle =  rad2deg(atan2(dir.y, dir.x))
	self.position = pos
	self.position += dir * dimension.x * 1
	self.position.y += 8
	if rot:
		rotation_degrees = angle
	$apparence.play("weapon" + str(apparence))
	$area / col.shape.extents = dimension

func _physics_process(delta):
	move_and_slide(dir * speed_) 

func _on_timerlife_timeout():
	destroy()

func destroy():
	queue_free() 

func _on_area_body_entered(body):
	if body is StaticBody2D:
		speed_ = 0
	if body is TileMap:
		speed_ = 0
	if body.is_in_group("boss") and allie_:
		body.life -= 1 
	if body.is_in_group("switch") and (id == 0 or id == 1 or id == 5):
		body.open()
	if body.is_in_group("lampe") and (id == 2):
		body.lightUp()
	if body.is_in_group("mob") and allie_:
		body.damage(damage_)
		queue_free() 
	if body.is_in_group("hero") and not allie_:
		body.hit(damage_)
