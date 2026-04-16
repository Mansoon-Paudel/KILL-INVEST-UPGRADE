extends Area2D

@onready var enemy = get_parent()

func _on_body_entered(body):
	if body.name == "Player":
		enemy.player = body

func _on_body_exited(body):
	if body.name == "Player":
		enemy.player = null
