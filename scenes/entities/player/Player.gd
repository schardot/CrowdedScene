extends CharacterBody2D

@export var  speed := 300.0

var goal_color: GameTypes.ColorType
var has_goal := false
var can_move_left := true
var can_move_right := true
var can_move_up := true
var can_move_down := true

@onready var push_area := $PushArea
@onready var thought_bubble := $ThoughtBubble

func _physics_process(delta: float) -> void:
	var input_dir := Vector2.ZERO
	if Input.is_action_just_pressed("push"):
		push_npcs()
	if Input.is_action_pressed("ui_right") && can_move_right:
		input_dir.x += 1
	if Input.is_action_pressed("ui_left") && can_move_left:
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down") && can_move_down:
		input_dir.y += 1
	if Input.is_action_pressed("ui_up") && can_move_up:
		input_dir.y -= 1

	# 1. Start from current velocity
	var desired_velocity = input_dir.normalized() * speed

	# 2. Blend input with existing velocity
	velocity = velocity.move_toward(desired_velocity, speed * 6 * delta)

	# 3. Move
	move_and_slide()

	# 4. Apply crowd push AFTER movement
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider.is_in_group("crowd"):
			velocity += collision.get_normal() * 120


func _ready() -> void:
	thought_bubble.set_icon(
		GameTypes.ColorType.BLUE
	)

func set_goal(color: GameTypes.ColorType):
	goal_color = color
	has_goal = true
	thought_bubble.show()
	thought_bubble.set_icon(color)

func clear_goal():
	has_goal = false
	thought_bubble.hide()

func set_movement(left, right, up, down):
	can_move_left = left
	can_move_right = right
	can_move_down = down
	can_move_up = up

func push_npcs():
	var bodies = push_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("crowd"):
			var dir = (body.global_position - global_position).normalized()
			body.apply_push(dir)
