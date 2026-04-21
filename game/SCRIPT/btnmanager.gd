extends Node

@onready var death_panel: Panel = $"../CanvasLayer/DEATH"

func _ready() -> void:
	death_panel.hide()

func _process(_delta: float) -> void:
	if GameState.player_dead and not death_panel.visible:
		death_panel.show()

func _on_button_2_button_up() -> void:
	_reset_and_go("res://SCENE/workd/world.tscn")

func _on_button_3_button_up() -> void:
	_reset_and_go("res://SCENE/Shop.tscn")

func _on_button_4_button_up() -> void:
	_reset_and_go("res://SCENE/levels.tscn")

func _on_button_pressed() -> void:
	_reset_and_go("res://SCENE/Skill-tree.tscn")

func _reset_and_go(scene: String) -> void:
	GameState.player_dead = false
	GameState.health = GameState.get_stat("health") 
	get_tree().change_scene_to_file(scene)
