extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK,
	STUN,
	DEAD
}

@export var speed: float = 100
@export var gravity = 900
@export var health = 3
@export var knockback_force = 200
@export var stun_duration = 0.5

var current_state = State.IDLE
var player = null
var can_attack = false
var is_attacking = false
var is_stunned = false
var knockback_velocity = Vector2.ZERO  # was float, must be Vector2

@onready var lft: CollisionShape2D = $CollisionShape2D_left
@onready var rgt: CollisionShape2D = $CollisionShape2D_right
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var detection = $DetectionZone
@onready var attack_zone = $AttackZone

func _ready() -> void:
	detection.body_entered.connect(_on_detection_entered)
	detection.body_exited.connect(_on_detection_exited)
	attack_zone.body_entered.connect(_on_attack_zone_entered)
	attack_zone.body_exited.connect(_on_attack_zone_exited)

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
			velocity.x = move_toward(velocity.x, 0, knockback_force * delta)  # decelerate
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
	current_state = State.CHASE

func take_damage(amount):
	if current_state == State.DEAD:
		return
	health -= amount  # was inside the return block by mistake!
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
	velocity = direction * knockback_force  # apply knockback immediately
	sprite.play("hurt")
	await sprite.animation_finished
	is_stunned = false
	current_state = State.CHASE  # go back to chase not attack after stun

func die():
	if current_state != State.DEAD:
		return
	sprite.play("Die")
	set_physics_process(false)  # stop movement while dying
	await get_tree().create_timer(1).timeout
	GameState.Kill += 1
	queue_free()

# Detection zone signals
func _on_detection_entered(body):
	if body is Player:
		player = body
		if current_state == State.IDLE:
			current_state = State.CHASE

func _on_detection_exited(body):
	if body is Player:
		player = null
		if not is_stunned:
			current_state = State.IDLE

# Attack zone signals
func _on_attack_zone_entered(body):
	if body is Player:
		can_attack = true
		if current_state == State.CHASE:
			current_state = State.ATTACK

func _on_attack_zone_exited(body):
	if body is Player:
		can_attack = false
		if current_state == State.ATTACK and not is_attacking:
			current_state = State.CHASE
