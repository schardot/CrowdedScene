@tool
extends Area2D

@export var shape: GameTypes.ShapeType = GameTypes.ShapeType.CIRCLE:
	set(value):
		shape = value
		_sync_icon()

@export var color: GameTypes.ColorType = GameTypes.ColorType.RED:
	set(value):
		color = value
		_sync_icon()

@onready var icon_rect: ColorRect = $Visuals/Icon/ColorRect
@onready var icon_label: Label = $Visuals/Icon/Label

func _ready():
	_sync_icon()
	add_to_group("stores")

func _sync_icon():
	if not icon_rect or not icon_label:
		return

	icon_label.text = _shape_to_symbol(shape)
	icon_rect.color = _color_to_color(color)


func _shape_to_symbol(s: GameTypes.ShapeType) -> String:
	match s:
		GameTypes.ShapeType.CIRCLE:
			return "●"
		GameTypes.ShapeType.SQUARE:
			return "■"
		GameTypes.ShapeType.TRIANGLE:
			return "▲"
		GameTypes.ShapeType.DIAMOND:
			return "◆"
		GameTypes.ShapeType.STAR:
			return "★"
		_:
			return "?"

func _color_to_color(c: GameTypes.ColorType) -> Color:
	match c:
		GameTypes.ColorType.RED:
			return Color.RED
		GameTypes.ColorType.GREEN:
			return Color.GREEN
		GameTypes.ColorType.BLUE:
			return Color.BLUE
		GameTypes.ColorType.YELLOW:
			return Color.YELLOW
		_:
			return Color.WHITE

func _on_store_body_entered(body):
	if not body.is_in_group("player"):
		return

	if not body.has_goal:
		return

	if body.goal_shape == shape and body.goal_color == color:
		_correct_feedback()
	else:
		_wrong_feedback()

func _correct_feedback():
	print("🎄 CORRECT STORE")
	icon_rect.modulate = Color(1, 1, 1, 1)
	icon_rect.scale = Vector2(1.3, 1.3)

func _wrong_feedback():
	print("❌ WRONG STORE")
	icon_rect.modulate = Color(1, 0.3, 0.3)
