extends Node2D

@onready var player = $Player

var stores: Array = []


func _unhandled_input(event):
	if event.is_action_pressed("ui_quit"):
		get_tree().quit()

func _ready():
	stores = get_tree().get_nodes_in_group("stores")
	generate_assignment()

func generate_assignment():
	if stores.is_empty():
		push_error("No stores available for assignment")
		return

	var store = stores.pick_random()

	var assignment_shape = store.shape
	var assignment_color = store.color

	player.set_goal(assignment_shape, assignment_color)

	print(
		"ASSIGNMENT:",
		assignment_shape,
		assignment_color,
		"->",
		store.name
	)
