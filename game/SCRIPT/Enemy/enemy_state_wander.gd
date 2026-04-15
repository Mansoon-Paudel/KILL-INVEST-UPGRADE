class_name EnemyStateWander extends EnemyState

@export var anim_name: String = "Walk"
@export var wander_speed: float = 20
@export_category("AI")
@export var state_animation_duration: float = 0.7
@export var state_cycle_min: int = 1
@export var state_cycle_max: int = 3
@export var next_state: EnemyState

var _timer: float = 0
var _direction: Vector2

func _init() -> void:
	pass

func enter() -> void:
	_timer = randf_range(state_cycle_min, state_cycle_max) * state_animation_duration
	var rand = randi_range(0, 3)
	_direction = enemy.DIR4[rand]
	enemy.velocity = _direction * wander_speed
	enemy.set_direction(_direction)
	enemy.UpdateAnimation(anim_name)

func exit() -> void:
	pass

func process(_delta: float) -> EnemyState:
	_timer -= _delta
	if _timer <= 0:
		return next_state
	return null

func physics(_delta: float) -> EnemyState:
	
	return null
