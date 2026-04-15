extends Button

@onready var button: Button = $"."
@onready var player: Player = $"../../player"


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
	if get_tree().current_scene.name == "World":
		GameState.player_position=player.position
		print(GameState.player_position)
	get_tree().change_scene_to_file("res://SCENE/levels.tscn")
