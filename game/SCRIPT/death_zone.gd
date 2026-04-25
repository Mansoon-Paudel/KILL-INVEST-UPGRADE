extends Area2D





func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		GameState.player_dead = true
	else:
		body.queue_free()
