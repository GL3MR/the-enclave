extends Camera2D

func _ready() -> void:
	Events.connect("room_entered", self, "_on_room_entered")

func _on_room_entered(room):
	global_position = room.global_position
