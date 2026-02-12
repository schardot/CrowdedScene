extends Control

@export var game_scene :PackedScene
@export var tutorial_scene: PackedScene

func _on_start_game_pressed():
	get_tree().change_scene_to_packed(game_scene)

func _on_tutorial_pressed():
	get_tree().change_scene_to_packed(tutorial_scene)
