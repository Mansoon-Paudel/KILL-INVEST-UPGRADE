class_name Player extends CharacterBody2D

var cardinal_direction : Vector2 = Vector2.DOWN
var move_speed = 100
var direction: Vector2 = Vector2.ZERO
@onready var hurtbox: HurtBox = $Interactions/Hurtbox
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var state : String = "Idle"
var new_state : String
var is_attacking : bool = false

signal DirectionChanged(new_direction:Vector2) 

func _ready() -> void:
	GameState.player = self
	UpdateAnimation()
	sprite_2d.animation_finished.connect(_on_animation_finished)

func _process(delta: float) -> void:
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	direction.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	direction.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	velocity = direction * move_speed
	
	var direction_changed = Set_direction()
	var state_changed = Set_state()
	
	if direction_changed or state_changed:
		UpdateAnimation()
	
	if Input.is_action_just_pressed("Attack"):
		Start_attack()

func _physics_process(delta: float) -> void:
	move_and_slide()

func Start_attack() -> void:
	is_attacking = true
	state = "Attack"
	UpdateAnimation()
	await get_tree().create_timer(0.15).timeout
	hurtbox.monitoring=true


func _on_animation_finished() -> void:
	if state == "Attack":
		is_attacking = false
		state = "Idle"
		hurtbox.monitoring=false
		UpdateAnimation()

func Set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false

	var new_dir : Vector2

	if abs(direction.x) >= abs(direction.y):
		if direction.x > 0:
			new_dir = Vector2.RIGHT
		else:
			new_dir = Vector2.LEFT
	else:
		if direction.y > 0:
			new_dir = Vector2.DOWN
		else:
			new_dir = Vector2.UP

	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	cardinal_direction = new_dir
	return true
	
	

func Set_state() -> bool:
	if is_attacking:
		return false
	
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
