class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction: Vector2)
signal enemy_damaged()

const DIR4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var hp: int = 3

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: HitBox = $hitbox
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine

var cardinal_direction: Vector2 = Vector2.DOWN
var invulnerable: bool = false

func _ready() -> void:
	hitbox.Damaged.connect(_on_damaged)
	state_machine.initialize(self)

func set_direction(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		return
	cardinal_direction = dir
	direction_changed.emit(cardinal_direction)

func UpdateAnimation(anim_name: String) -> void:
	animated_sprite_2d.play(anim_name + "_" + AnimDirection())

func AnimDirection() -> String:
	if cardinal_direction == Vector2.UP:
		return "Up"
	elif cardinal_direction == Vector2.DOWN:
		return "Down"
	elif cardinal_direction == Vector2.LEFT:
		return "Left"
	else:
		return "Right"

func _on_damaged(damage: int) -> void:
	if invulnerable:
		return
	hp -= damage
	emit_signal("enemy_damaged")
	print("Enemy HP: ", hp)
	if hp <= 0:
		die()

func die() -> void:
	GameState.Coin += 1
	GameState.Crystal += 1
	queue_free()
func _physics_process(delta: float) -> void:
	move_and_slide()
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		if col.get_collider() is Player:
			
			var push_dir = col.get_collider().global_position - global_position
			col.get_collider().velocity += push_dir.normalized() * 200
			
			global_position -= col.get_normal() * col.get_depth()
