extends Area2D

onready var audio_energy: AudioStreamPlayer2D = $energy
onready var sprite_batery: AnimatedSprite = $apparence
onready var sprite_batery_shadow: Sprite = $shadow
onready var colission_batery: CollisionShape2D = $CollisionShape2D

func _on_Batery_body_entered(body):
	if body.is_in_group("hero"):
		audio_energy.play()
		sprite_batery.set_deferred("visible", false)
		sprite_batery_shadow.set_deferred("visible", false)
		colission_batery.set_deferred("disabled", true)
		Events.batery_count += 1
		
	

func _on_energy_finished():
	queue_free()
