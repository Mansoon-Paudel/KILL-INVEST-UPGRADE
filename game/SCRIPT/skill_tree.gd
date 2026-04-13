extends Control
@onready var content: Control = $Contents

var is_dragging = false
var drag_start = Vector2.ZERO
var container_start = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE or MOUSE_BUTTON_RIGHT:
			is_dragging = event.pressed
			drag_start = event.position
			container_start = content.position

	if event is InputEventMouseMotion and is_dragging:
		var offset = event.position - drag_start
		content.position = container_start + offset


func _on_button_pressed() -> void:
	pass # Replace with function body.
