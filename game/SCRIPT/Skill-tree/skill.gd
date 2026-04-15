extends Button
@onready var button: Button = $"."
@onready var panel: Panel = $Panel

func _process(delta):
	if button.button_pressed:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_10/Complete/button_small-PUSH.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_10/Complete/button_small-HOVER.png")
	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_10/Complete/button_small.png")
func _on_button_down() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_10/Complete/button_small-PUSH.png")


func _on_button_up() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_10/Complete/button_small.png")
	if panel.visible==true:
		panel.hide()
	else:
		panel.show()
	
