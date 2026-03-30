extends CharacterBody2D

@export var speed: float = 300.0

var street: Area2D
var direction: Vector2 = Vector2.DOWN

@onready var hitbox: Area2D = $Hitbox
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	if hitbox and not hitbox.body_entered.is_connected(_on_hitbox_body_entered):
		hitbox.body_entered.connect(_on_hitbox_body_entered)

func spawn_car(street_ref: Area2D) -> void:
	street = street_ref

	var spawn_pos: Vector2 = street.call("get_spawn_point")
	global_position = spawn_pos

	var street_center: Vector2 = street.call("get_center")
	direction = Vector2.DOWN if spawn_pos.y < street_center.y else Vector2.UP
	_nudge_inside_street()

func _physics_process(_delta: float) -> void:
	velocity = direction * speed
	move_and_slide()

	_clamp_to_street()
	_check_recycle()

func _check_recycle() -> void:
	if not street:
		return

	var margin: float = _get_world_margin()
	var exit: int = street.call("get_y_exit", global_position, margin)
	if exit == 0:
		return

	var spawn_top: bool = exit == 1
	global_position = street.call("get_spawn_line", spawn_top)
	direction = Vector2.DOWN if spawn_top else Vector2.UP
	_nudge_inside_street()

func _nudge_inside_street() -> void:
	# Spawn lines are exactly on the street edge; nudge inside by our half-height
	# to avoid interacting with world bounds/colliders at the edges.
	var margin: float = _get_world_margin()
	if direction.y > 0.0:
		global_position.y += margin
	else:
		global_position.y -= margin

func _get_world_margin() -> float:
	var cs: CollisionShape2D = get_node_or_null("CollisionShape2D")
	if not cs:
		return 0.0
	var shape := cs.shape
	if shape is RectangleShape2D:
		var world_scale: Vector2 = cs.global_transform.get_scale()
		return (shape.size.y * 0.5) * abs(world_scale.y)
	return 0.0

func _get_world_radius() -> float:
	if not collision_shape:
		return 0.0
	var shape := collision_shape.shape
	var local_radius := 0.0
	if shape is CircleShape2D:
		local_radius = shape.radius
	elif shape is CapsuleShape2D:
		local_radius = shape.radius
	elif shape is RectangleShape2D:
		local_radius = max(shape.size.x, shape.size.y) * 0.5
	var s: Vector2 = collision_shape.global_transform.get_scale()
	return local_radius * max(abs(s.x), abs(s.y))

func _clamp_to_street() -> void:
	if not street:
		return
	var radius: float = _get_world_radius()
	global_position = street.call("clamp_point_to_street", global_position, radius)

func _on_hitbox_body_entered(body: Node) -> void:
	if body and body.is_in_group("player") and body.has_method("die"):
		body.call("die")
