extends Area2D

@onready var collision_shape : CollisionShape2D = $CollisionShape2D

func get_spawn_point() -> Vector2:
	var shape := collision_shape.shape
	
	if shape is RectangleShape2D:
		var half : Vector2 = shape.size / 2.0
		
		var x:= randf_range(-half.x, half.x)
		
		var spawn_top := randf() < 0.5
		var y := -half.y if spawn_top else half.y
		
		var local := Vector2(x, y)
		
		return collision_shape.global_transform * local
		
	push_error("Street: unsupported collision shape")
	return global_position

func clamp_point_to_street(world_point: Vector2, world_margin: float) -> Vector2:
	var shape := collision_shape.shape

	if shape is RectangleShape2D:
		var inv := collision_shape.global_transform.affine_inverse()
		var local_point := inv * world_point

		var half_size: Vector2 = shape.size * 0.5

		local_point.x = clamp(
			local_point.x,
			-half_size.x + world_margin,
			half_size.x - world_margin
		)

		return collision_shape.global_transform * local_point

	return collision_shape.global_position
	
func get_center():
	return collision_shape.global_position

func get_spawn_line(top: bool) -> Vector2:
	var shape := collision_shape.shape
	if shape is RectangleShape2D:
		var half: Vector2 = shape.size / 2.0
		var x := randf_range(-half.x, half.x)
		var y := -half.y if top else half.y
		return collision_shape.global_transform * Vector2(x, y)
	push_error("Street: unsupported collision shape")
	return global_position

func get_y_exit(world_pos: Vector2, margin: float = 0.0) -> int:
	var shape := collision_shape.shape
	if shape is RectangleShape2D:
		var local_y := (collision_shape.global_transform.affine_inverse() * world_pos).y
		var half_y : float = shape.size.y / 2.0
		if local_y < -(half_y + margin):
			return -1
		if local_y > half_y + margin:
			return 1
	return 0
