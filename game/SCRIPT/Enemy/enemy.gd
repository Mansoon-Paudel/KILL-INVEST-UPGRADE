extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK,
	STUN,
	DEAD
}

var current_state = State.IDLE
@export var speed: float = 100
@export var gravity = 900
@export var health = 3
@export var stun_duration = 0.5

var player = null
var can_attack = false
var is_attacking = false
var is_stunned = false
@onready var lft: CollisionShape2D = $CollisionShape2D_left
@onready var  rgt: CollisionShape2D = $CollisionShape2D_right
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
			sprite.play("idle")
			if player:
				current_state = State.CHASE
		State.CHASE:
			chase_player()
			sprite.play("walk")
			if can_attack:
				current_state = State.ATTACK
		State.ATTACK:
			attack()
		State.STUN:
			velocity.x = 0
		State.DEAD:
			die()

func chase_player():
	if player == null:
		current_state = State.IDLE
		return
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * speed
	if direction<0:
		sprite.flip_h = true
		
		lft.disabled=true
		rgt.disabled=false
	else:
		sprite.flip_h = false
		rgt.disabled=true
		lft.disabled=false
		
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
	health -= amount
	if health <= 0:
		current_state = State.DEAD
	else:
		stun()

func stun():
	if is_stunned:
		return
	is_stunned = true
	current_state = State.STUN
	sprite.play("idle")
	await get_tree().create_timer(stun_duration).timeout
	is_stunned = false
	current_state = State.CHASE
	
func die():
	sprite.play("idle")  # replace with "death" animation if you have one
	await get_tree().create_timer(0.5).timeout
	queue_free()
