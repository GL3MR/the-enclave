extends Control

func _ready():
	pass



func _on_github_pressed():
	OS.shell_open("https://github.com/GL3MR")



func _on_voltar_pressed():
	SceneTransition.change_scene("res://scene/Menu.tscn")


func _on_link_ronan_pressed():
	OS.shell_open("https://www.linkedin.com/in/ronan-vc-junior/")


func _on_link_gabriel_pressed():
	OS.shell_open("https://www.linkedin.com/in/gabriel-silva-taveira/")


func _on_link_luis_pressed():
	OS.shell_open("https://www.linkedin.com/in/luís-ricardo-santos-de-lima-8476a3244/")


func _on_link_lucio_pressed():
	OS.shell_open("https://www.linkedin.com/in/lucio-junqueira-66838821a/")


func _on_link_milton_pressed():
	OS.shell_open("https://www.linkedin.com/in/milton-alexandre-souza-demarchi-46b3a8152/")
