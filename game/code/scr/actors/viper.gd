class_name viper
extends actor

var player_chase = false
var player = null
var speedv = 30


func _on_Area2D_body_entered(body):
	player = body
	player_chase = true


func _on_Area2D_body_exited(body):
	player = null
	player_chase = false
	

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speedv
		$AnimatedSprite.play("walking")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
			
	else:
		$AnimatedSprite.play("idle")
