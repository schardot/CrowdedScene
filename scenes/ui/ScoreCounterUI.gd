class_name ScoreCounterUI
extends Control

@export var pad_h: float = 14.0
@export var pad_v: float = 10.0
@export var icon_height: float = 16.0
@export var label_style: LabelSettings = preload("res://scenes/ui/ScoreCounterLabelSettings.tres")

@onready var score_button: Button = $Background/MarginContainer/ScoreButton


func _ready() -> void:
	_apply_typography()
	_apply_icon_size()
	reset()


func _notification(what: int) -> void:
	if what == NOTIFICATION_THEME_CHANGED:
		call_deferred("_apply_typography")
		call_deferred("_apply_icon_size")
		call_deferred("_fit_to_text")


func set_value(value: int) -> void:
	if score_button:
		score_button.text = str(value)
	call_deferred("_fit_to_text")


func reset() -> void:
	set_value(0)


func _apply_typography() -> void:
	if score_button == null or label_style == null:
		return
	if label_style.font:
		score_button.add_theme_font_override("font", label_style.font)
	score_button.add_theme_font_size_override("font_size", label_style.font_size)
	score_button.add_theme_color_override("font_color", label_style.font_color)


func _apply_icon_size() -> void:
	if score_button == null:
		return
	var tex: Texture2D = score_button.icon
	if tex == null:
		score_button.remove_theme_constant_override("icon_max_width")
		call_deferred("_fit_to_text")
		return
	var sz := tex.get_size()
	if sz.y <= 0.0 or icon_height <= 0.0:
		score_button.remove_theme_constant_override("icon_max_width")
	else:
		var max_w := icon_height * (sz.x / sz.y)
		score_button.add_theme_constant_override("icon_max_width", int(max_w))
	call_deferred("_fit_to_text")


func _fit_to_text() -> void:
	if score_button == null:
		return
	var ms := score_button.get_minimum_size()
	custom_minimum_size = ms + Vector2(pad_h * 2.0, pad_v * 2.0)
