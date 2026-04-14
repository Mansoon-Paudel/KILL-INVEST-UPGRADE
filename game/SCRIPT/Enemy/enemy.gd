class_name palnt extends CharacterBody2D

func _ready() -> void:
	$hitbox.Damaged.connect(TakeDamage)
	

func TakeDamage (_damage : int) -> void:
	queue_free()
