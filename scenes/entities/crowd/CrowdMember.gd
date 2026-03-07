extends CharacterBody2D
class_name CrowdMember

@export var speed := 20.0

var street: Area2D
var direction := Vector2.ZERO
var push_offset: Vector2 = Vector2.ZERO
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	pass

func _physics_process(_delta):
	velocity = direction * speed
	
	if push_offset != Vector2.ZERO:
		velocity += push_offset
		push_offset = Vector2.ZERO
		
	move_and_slide()

	if street:
		var radius := get_world_radius()
		global_position = street.clamp_point_to_street(global_position, radius)

func apply_push(dir: Vector2):
	push_offset += dir * 3000

	
func _pick_new_direction():
	direction = Vector2(0, [-1, 1].pick_random())

func set_direction_from_spawn(spawn_pos: Vector2, street_center: Vector2):
	if spawn_pos.y < street_center.y:
		direction = Vector2.DOWN
	else:
		direction = Vector2.UP

func get_world_radius() -> float:
	var shape := collision_shape.shape
	var local_radius := 0.0

	if shape is CircleShape2D:
		local_radius = shape.radius
	elif shape is CapsuleShape2D:
		local_radius = shape.radius
	elif shape is RectangleShape2D:
		local_radius = max(shape.size.x, shape.size.y) * 0.5

	var _scale := collision_shape.global_transform.get_scale()
	return local_radius * max(_scale.x, _scale.y)
