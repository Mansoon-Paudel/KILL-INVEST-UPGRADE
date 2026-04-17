# detection_zone.gd
extends Area2D
@onready var enemy = get_parent()

func _on_body_entered(body):
	if body is Player:
		enemy.player = body
		if enemy.current_state == enemy.State.IDLE:
			enemy.current_state = enemy.State.CHASE

func _on_body_exited(body):
	if body is Player:
		enemy.player = null
		if not enemy.is_stunned:
			enemy.current_state = enemy.State.IDLE
