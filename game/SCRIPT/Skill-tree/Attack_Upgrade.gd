extends Button
@onready var button: Button = $"."
@onready var panel: Panel = $Panel

func _process(delta):
	if button.button_pressed:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
	elif button.is_hovered():
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray-HOVER.png")
	else:
		button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
func _on_button_down() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray-PUSH.png")


func _on_button_up() -> void:
	button.icon = load("res://ASSETS/UI/Sliced Images/Part_4/Actions Bar/button_gray.png")
	if GameState.Coin >= 5 and GameState.Crystal >=2:
		GameState.damage +=1
		GameState.Coin -= 5
		GameState.Crystal -= 2
