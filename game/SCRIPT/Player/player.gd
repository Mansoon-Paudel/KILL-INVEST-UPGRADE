class_name Player extends CharacterBody2D

const SPEED = 230.0
const JUMP_VELOCITY = -460.0
const COYOTE_TIME = 0.13

@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D

var coyote_timer = 0.0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	# Jump
	if Input.is_action_just_pressed("Up"):
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0

	# Movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 18)

	move_and_slide()
	UpdateAnimation()

func UpdateAnimation() -> void:
	if velocity.x > 1:
		sprite2D.flip_h = false
	elif velocity.x < -1:
		sprite2D.flip_h = true

	if not is_on_floor():
		sprite2D.play("Jump")
	elif velocity.x > 1 or velocity.x < -1:
		sprite2D.play("Left")
	else:
		sprite2D.flip_h = false
		sprite2D.play("Idle")
