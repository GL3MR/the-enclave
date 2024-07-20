extends CanvasLayer

onready var buttons = get_tree().get_nodes_in_group("buttonswitch")

var text = ["Saber", "Buster", "Puncher"]

func _ready():
	for button in buttons:
		if button.id > get_parent().id_weapon_number - 1:
			for N in button.get_children():
				N.visible = false
		else:
			button.connect("pressed", self, "switch", [button.id])

func switch(id):
	$hudroue/Label.set_text(text[id])
	get_parent().id_weapon = id
	get_parent().apparence_hud()
	if $hudroue/anim.get_current_animation() == "close":
		$hudroue/anim.play("open")
	elif $hudroue/anim.get_current_animation() == "rien":
		$hudroue/anim.play("rien")
	
	for button in buttons:
		if button.id == id:
			button.pressed = true
		else:
			button.pressed = false

func rien():
	$hudroue/anim.play("rien")

func close():
	$hudroue/anim.play("close")

func destroy():
	queue_free()
