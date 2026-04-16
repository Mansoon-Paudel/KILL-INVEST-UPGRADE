extends Area2D

@onready var enemy = get_parent()

func _on_area_entered(area):
	print("Hitbox hit by: ", area.name, " groups: ", area.get_groups())
	if area.is_in_group("player_attack"):
		enemy.take_damage(1)
