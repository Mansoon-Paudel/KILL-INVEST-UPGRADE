extends Node

@onready var player: Player = $player

func _on_button_3_pressed() -> void:
	pass


func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/world.tscn")
func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/Skill-tree.tscn")
