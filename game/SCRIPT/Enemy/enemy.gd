# enemy.gd
extends CharacterBody2D
enum State {
	IDLE,
	CHASE,
	ATTACK,
	STUN,
	DEAD
}
@export var speed: float = 100
@export var gravity: float = 900
@export var health = 3
@export var knockback_force = 100
@export var stun_duration = 0.5
var current_state = State.IDLE
var player = null
var can_attack = false
var is_attacking = false
var is_stunned = false
var is_dying = false
var knockback_velocity = Vector2.ZERO
@onready var lft: CollisionShape2D = $CollisionShape2D_left
@onready var rgt: CollisionShape2D = $CollisionShape2D_right
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection = $DetectionZone
@onready var attack_zone = $AttackZone

func _physics_process(delta):
	apply_gravity(delta)
	state_machine(delta)
	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func state_machine(delta):
	match current_state:
		State.IDLE:
			velocity.x = 0
			sprite.play("idle")
		State.CHASE:
			chase_player()
			sprite.play("walk")
			if can_attack:
				current_state = State.ATTACK
		State.ATTACK:
			attack()
		State.STUN:
			velocity.x = move_toward(velocity.x, 0, knockback_force * delta)
		State.DEAD:
			die()

func chase_player():
	if player == null:
		current_state = State.IDLE
		return
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * speed
	if direction < 0:
		sprite.flip_h = true
		rgt.disabled = true
		lft.disabled = false
	else:
		sprite.flip_h = false
		lft.disabled = true
		rgt.disabled = false

func attack():
	if is_attacking:
		return
	is_attacking = true
	velocity.x = 0
	sprite.play("attack")
	await sprite.animation_finished
	if can_attack and player != null:
		player.take_damage(1)
	is_attacking = false
	# Return to chase if player is still around, otherwise idle
	if can_attack and player != null:
		current_state = State.ATTACK
	elif player != null:
		current_state = State.CHASE
	else:
		current_state = State.IDLE

func take_damage(amount):
	if current_state == State.DEAD:
		return
	health -= amount
	if health <= 0:
		current_state = State.DEAD
	else:
		if player != null:
			stun(player.global_position)

func stun(from_position: Vector2):
	if is_stunned:
		return
	is_stunned = true
	current_state = State.STUN
	var direction = (global_position - from_position).normalized()
	velocity = direction * knockback_force
	sprite.play("hurt")
	await sprite.animation_finished
	is_stunned = false
	current_state = State.CHASE

func die():
	if is_dying:
		return
	is_dying = true
	sprite.play("Die")
	set_physics_process(false)
	await get_tree().create_timer(1).timeout
	GameState.Kill += 1
	GameState.Coin += 2
	GameState.Crystal += 1
	queue_free()
