extends Node

# -----------------
# LIFECYCLE
# -----------------

func _ready() -> void:
	randomize()

# -----------------
# SCREEN HELPERS
# -----------------

func get_screen_size() -> Vector2:
	return get_viewport().get_visible_rect().size

# -----------------
# RANDOM HELPERS
# -----------------

func random_bool() -> bool:
	return randf() < 0.5

func random_sign() -> float:
	return 1.0 if random_bool() else -1.0

# -----------------
# COLOR HELPERS
# -----------------

func color_type_to_color(c: GameTypes.ColorType) -> Color:
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

# -----------------
# GLOBAL SIGNALS
# -----------------

# Emitted when the player completes an assignment (reaches the correct store)
signal assignment_completed

# Emitted when the player dies (e.g. hit by a car)
signal player_died
