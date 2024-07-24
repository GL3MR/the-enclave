extends RigidBody2D

func _ready():
	$SpirkProjectileAnimation.animation = "pulsing"
	$SpirkProjectileAnimation.play()

# codar queue_free


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
