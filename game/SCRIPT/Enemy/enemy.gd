class_name Enemy extends CharacterBody2D


signal direction_changed(new_direction:Vector2)
signal enemy_damaged()
const DIR4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.UP, Vector2.LEFT]
@export var hp : int= 3 
@onready var sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: HitBox = $hitbox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

var cardinal_direction: Vector2 = Vector2.DOWN
var direction: Vector2 =Vector2.ZERO
var player : Player
var invulnerable: bool = false


func _ready() -> void:
	state_machine.initialize(self)
	player=GameState.player

func _physics_process(delta: float) -> void:
	move_and_slide()


func set_direction(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false

	var direction_id:int = int(round(
		(direction+cardinal_direction*0.1).angle()/TAU * DIR4.size()
	))
	
	var new_dir = DIR4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	direction_changed.emit(new_dir)
	 
	if cardinal_direction == Vector2.LEFT:
		sprite_2d.scale.x=-1
	else:
		sprite_2d.scale.x=1
	
	return true

func UpdateAnimation(state: String) -> void:
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
