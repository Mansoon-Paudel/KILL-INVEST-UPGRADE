extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var move_speed = 100
var direction: Vector2 = Vector2.ZERO

@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var state : String = "Idle"
var new_state : String

func _ready() -> void:
	UpdateAnimation()
func _process(delta: float) -> void:
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	velocity = direction * move_speed
	
	var direction_changed = Set_direction()  # now returns bool
	var state_changed = Set_state()
	
	if direction_changed or state_changed:
		UpdateAnimation()
func _physics_process(delta: float) -> void:
	move_and_slide()

func Set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false  
	
	var new_direction : Vector2
	
	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			new_direction = Vector2.RIGHT
		else:
			new_direction = Vector2.LEFT
	else:
		if direction.y > 0:
			new_direction = Vector2.DOWN
		else:
			new_direction = Vector2.UP
	
	if new_direction == cardinal_direction:
		return false  
	
	cardinal_direction = new_direction
	return true 
func Set_state() -> bool:
	if direction == Vector2.ZERO:
		new_state = "Idle"
	else:
		new_state = "Walk"
	
	if new_state == state:
		return false
	state = new_state
	return true

func UpdateAnimation() -> void:
	sprite_2d.play(state + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.UP:
		return "Up"
	elif cardinal_direction == Vector2.DOWN:
		return "Down"
	elif cardinal_direction == Vector2.LEFT:
		return "Left"
	else:
		return "Right"
