extends Button

@onready var button: Button = $"."
@onready var label: Label = $Label

func _process(delta: float) -> void:
	if button.button_pressed:
		label.self_modulate.a = 0.6
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_orange-PUSH.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_orange-HOVER.png")
		label.self_modulate.a = 1
	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_orange.png")
		label.self_modulate.a = 0.8
