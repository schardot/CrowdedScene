extends Node2D

@onready var icon_rect := $ColorRect

func set_icon(color: GameTypes.ColorType):
	icon_rect.color = Globals.color_type_to_color(color)
	visible = true
