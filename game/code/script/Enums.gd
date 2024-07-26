extends Node

enum DoorColor {
	RED,
	GREEN,
	BLUE,
	NONE
}

var door_color_to_string = {
	DoorColor.RED: "red",
	DoorColor.GREEN: "green",
	DoorColor.BLUE: "blue",
	DoorColor.NONE: "none"
}

var string_to_door_color = {
	"red": DoorColor.RED,
	"green": DoorColor.GREEN,
	"blue": DoorColor.BLUE,
	"none": DoorColor.NONE
}
