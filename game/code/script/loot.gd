extends Area2D

var regen = 2
onready var player_a = get_tree().get_nodes_in_group("hero") 
onready var player = player_a[0]
onready var audio_energy: AudioStreamPlayer2D = $energy
onready var sprite_loot: AnimatedSprite = $apparence
onready var sprite_loot_shadow: Sprite = $shadow
onready var colission_loot: CollisionShape2D = $CollisionShape2D

func _on_loot_body_entered(body):
	if body.is_in_group("hero"):
		audio_energy.play()
		sprite_loot.set_deferred("visible", false)
		sprite_loot_shadow.set_deferred("visible", false)
		colission_loot.set_deferred("disabled", true)
		body.life = min(body.max_life, (body.life + regen))
			

func _on_energy_finished():
	queue_free()
