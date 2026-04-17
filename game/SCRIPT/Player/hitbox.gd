extends Area2D

@onready var enemy = get_parent()

func _on_area_entered(area):
	if area.is_in_group("player_attack"):
		enemy.take_damage(GameState.damage)
