extends CharacterBody2D

@export var speed := 60.0

var street: Area2D
var direction := Vector2.ZERO
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	_pick_new_direction()


func _physics_process(_delta):
	velocity = direction * speed
	move_and_slide()

	if street:
		var radius := get_world_radius()
		global_position = street.clamp_point_to_street(global_position, radius)
	
	if randi() % 120 == 0:
		_pick_new_direction()


func _pick_new_direction():
	direction = Vector2(
		randf_range(-1, 1),
		randf_range(-1, 1)
	).normalized()

func get_world_radius() -> float:
	var shape := collision_shape.shape
	var local_radius := 0.0

	if shape is CircleShape2D:
		local_radius = shape.radius
	elif shape is CapsuleShape2D:
		local_radius = shape.radius
	elif shape is RectangleShape2D:
		local_radius = max(shape.size.x, shape.size.y) * 0.5

	# Convert local radius to world units using scale
	var _scale := collision_shape.global_transform.get_scale()
	return local_radius * max(_scale.x, _scale.y)
