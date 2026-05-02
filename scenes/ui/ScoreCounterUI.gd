class_name ScoreCounterUI
extends CanvasLayer

@onready var label: Label = $MarginContainer/Label


func _ready() -> void:
	reset()


func set_value(value: int) -> void:
	if label:
		label.text = str(value)


func reset() -> void:
	set_value(0)
