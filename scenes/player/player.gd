extends CharacterBody2D

@export var  speed := 200.0
var goal_shape: GameTypes.ShapeType
var goal_color: GameTypes.ColorType
var has_goal := true

func _physics_process(_delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed
	move_and_slide()

func _ready() -> void:
	goal_shape = GameTypes.ShapeType.CIRCLE
	goal_color = GameTypes.ColorType.RED
