extends Node



func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/Shop.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://SCENE/Skill-tree.tscn")


func _on_button_2_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/levelsect.tscn")
		#if GameState.yeti_killed== false:
	#	get_tree().change_scene_to_file("res://SCENE/workd/world.tscn")
	#elif  GameState.yeti_killed == true:
	#	get_tree().change_scene_to_file("res://SCENE/workd/world2.tscn")
	#elif  GameState.Snake_killed == true:
	#	get_tree().change_scene_to_file("res://SCENE/workd/world.tscn")
