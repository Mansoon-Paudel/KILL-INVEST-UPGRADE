extends Area2D

@onready var enemy = get_parent()

func _on_area_entered(area):
	if area.name == "PlayerAttack":
		enemy.take_damage(1)
