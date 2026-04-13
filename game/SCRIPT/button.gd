extends Button

@onready var button: Button = $"."
@onready var label: Label = $Label

func _process(delta):
	if button.button_pressed:
		label.self_modulate.a = 0.6
		button.icon = load("res://ASSETS/UI/Sliced Images/- Menu (large buttons)/button-PUSH.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/- Menu (large buttons)/button-HOVER.png")
		label.self_modulate.a = 1
	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/- Menu (large buttons)/button.png")
		label.self_modulate.a = 0.8
func _on_button_down() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/- Menu (large buttons)/button-PUSH.png")


func _on_button_up() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/- Menu (large buttons)/button.png")
	get_tree().change_scene_to_file("res://SCENE/levels.tscn")
