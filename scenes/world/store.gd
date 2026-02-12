@tool
extends Area2D

var completed := false
signal player_entered()
var blocked := true

@export var store_id: int
@export var color: GameTypes.ColorType = GameTypes.ColorType.RED:
	set(value):
		color = value
		_sync_icon()

@onready var icon_rect: ColorRect = $Visuals/Icon/ColorRect

func _ready():
	_sync_icon()
	add_to_group("stores")

func _sync_icon():
	if not icon_rect:
		return
	#icon_rect.color = Color.SADDLE_BROWN
	icon_rect.visible = false
	if blocked == false:
		icon_rect.color = _color_to_color(color)

func unblock_store():
	blocked = false
	icon_rect.color = _color_to_color(color)
	icon_rect.visible = true
	#$StaticBody2D/CollisionShape2D.disabled = false

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
		GameTypes.ColorType.PURPLE:
			return Color.PURPLE
		GameTypes.ColorType.ORANGE:
			return Color.ORANGE
		GameTypes.ColorType.CYAN:
			return Color.CYAN
		GameTypes.ColorType.PINK:
			return Color.PINK
		GameTypes.ColorType.BROWN:
			return Color.BROWN
		GameTypes.ColorType.WHITE:
			return Color.WHITE
		_:
			return Color.BLACK

func _on_store_body_entered(body):
	if not body.is_in_group("player"):
		return
	
	if completed:
		return
	if not body.has_goal:
		return

	if body.goal_color == color:
		_correct_feedback()
	else:
		_wrong_feedback()

func _correct_feedback():
	print("🎄 CORRECT STORE")
	completed = true
	emit_signal("player_entered")
	#get_tree().call_group("game", "on_assignment_completed")

func _wrong_feedback():
	print("❌ WRONG STORE")

#func set_physical_block(enabled: bool):
	#$StaticBody2D/CollisionShape2D.disabled = !enabled
