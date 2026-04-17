# attack_zone.gd
extends Area2D
@onready var enemy = get_parent()

func _on_body_entered(body):
	if body is Player:
		enemy.can_attack = true
		if enemy.current_state == enemy.State.CHASE:
			enemy.current_state = enemy.State.ATTACK

func _on_body_exited(body):
	if body is Player:
		enemy.can_attack = false
		if enemy.current_state == enemy.State.ATTACK and not enemy.is_attacking:
			enemy.current_state = enemy.State.CHASE
