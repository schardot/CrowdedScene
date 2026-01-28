extends Node

func _ready():
	print("SceneManager READY")
	
func go_to_game():
	get_tree().change_scene_to_file("res://scenes/main/Game.tscn")

func go_to_end_screen():
	get_tree().change_scene_to_file("res://scenes/ui/EndScreen.tscn")

func go_to_menu():
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")
