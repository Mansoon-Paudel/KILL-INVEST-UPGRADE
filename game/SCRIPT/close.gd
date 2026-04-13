extends Button

@onready var button: Button = $"."


func _process(delta):
	if button.button_pressed:

		button.icon = load("res://ASSETS/UI/Sliced Images/- Window & Containers/c_header_close-PUSH.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/- Window & Containers/c_header_close-HOVER.png")

	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/- Window & Containers/c_header_close.png")

func _on_button_down() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/- Window & Containers/c_header_close-PUSH.png")


func _on_button_up() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/- Window & Containers/c_header_close.png")
	get_tree().change_scene_to_file("res://SCENE/levels.tscn")
