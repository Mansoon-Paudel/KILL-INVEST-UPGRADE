extends Area2D

@onready var enemy = get_parent()

func _on_body_entered(body):
	if body.is_in_group("player"):
		enemy.can_attack = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		enemy.can_attack = false
