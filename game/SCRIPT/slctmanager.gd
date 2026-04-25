extends Node
@onready var button_2: Button = $"../Button2"
@onready var button_3: Button = $"../Button3"
@onready var button_4: Button = $"../Button4"
@onready var button_5: Button = $"../Button5"
@onready var button_6: Button = $"../Button6"
@onready var button_7: Button = $"../Button7"

func _process(delta: float) -> void:
	if  GameState.yeti_killed == true:
		button_2.show()
	if  GameState.Snake_killed == true:
		button_3.show()
	if GameState.Snake_killed2 == true:
		button_4.show()
	if GameState.ORC_killed == true:
		button_5.show()
	if GameState.ORC_killed2 == true:
		button_6.show()
	if GameState.ORC_killed3 == true:
		button_7.show()
func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world.tscn")


func _on_button_2_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world2.tscn")


func _on_button_3_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world3.tscn")


func _on_button_4_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world4.tscn")
	


func _on_button_5_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world5.tscn")


func _on_button_6_button_up() -> void:
	get_tree().change_scene_to_file("res://SCENE/workd/world6.tscn")


func _on_button_7_button_up() -> void:
	pass
