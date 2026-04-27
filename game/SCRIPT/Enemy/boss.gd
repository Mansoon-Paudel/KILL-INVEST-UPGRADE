extends CharacterBody2D

enum State {
	IDLE,
	CHASE,
	ATTACK,
	STUN,
	DEAD
}

@export var speed: float = 75
@export var gravity: float = 900
@export var health: float = 200
@export var knockback_force: float = 100
@export var stun_duration: float = 0.5
@export var arena_left: float = 2550
@export var arena_right: float = 3050

var current_state = State.IDLE
var player = null
var can_attack = false
var is_attacking = false
var is_stunned = false
var is_dying = false
var damage: float = 30
var anger_played: bool = false
var hit_cooldown: bool = false
const ATTACK_DELAY: float = 0.125
var attack_cooldown: float = 0.0
@onready var hitbox: Area2D = $Hitbox
@onready var hitbox_lft: CollisionShape2D = $Hitbox/CollisionShape2D_left
@onready var hitbox_rgt: CollisionShape2D = $Hitbox/CollisionShape2D_right
@onready var lft: CollisionShape2D = $CollisionShape2D_left
@onready var rgt: CollisionShape2D = $CollisionShape2D_right
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_zone: Area2D = $Attackzone
@onready var detection: Area2D = $DetectionZone

func _ready() -> void:
	hitbox_lft.disabled = true
	hitbox_rgt.disabled = false
	var scene = get_tree().current_scene.scene_file_path
func _physics_process(delta):
	if attack_cooldown > 0:
		attack_cooldown -= delta
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
			if velocity.x == 0:
				sprite.play("idle")
			else:
				sprite.play("walk")
			if attack_zone.overlaps_body(player) and player != null:
				can_attack = true
				current_state = State.ATTACK
		State.ATTACK:
			attack()
		State.STUN:
			velocity.x = move_toward(velocity.x, 0, knockback_force * delta)
			sprite.play("hurt")
		State.DEAD:
			die()

func chase_player():
	if player == null:
		current_state = State.IDLE
		return
	var direction = sign(player.global_position.x - global_position.x)
	if (global_position.x <= arena_left and direction < 0) or \
	   (global_position.x >= arena_right and direction > 0):
		velocity.x = 0
		return
	velocity.x = direction * speed
	if direction < 0:
		sprite.flip_h = true
		rgt.disabled = true
		lft.disabled = false
		hitbox_rgt.disabled = true
		hitbox_lft.disabled = false
	else:
		sprite.flip_h = false
		lft.disabled = true
		rgt.disabled = false
		hitbox_lft.disabled = true
		hitbox_rgt.disabled = false

func attack():
	if is_attacking or attack_cooldown > 0:
		return
	is_attacking = true
	velocity.x = 0
	var roll = randf()
	if roll < 0.15:
		sprite.play("Magic_Fire")
		await sprite.animation_finished
		if attack_zone.overlaps_body(player) and player != null:
			player.take_damage(int(damage) + 15)
	elif roll < 0.30:
		sprite.play("Magic_blade")
		await sprite.animation_finished
		if attack_zone.overlaps_body(player) and player != null:
			player.take_damage(int(damage) + 20)
	elif roll < 0.45:
		sprite.play("Magic_lightning")
		await sprite.animation_finished
		if attack_zone.overlaps_body(player) and player != null:
			player.take_damage(int(damage) + 25)
	else:
		sprite.play("attack")
		await sprite.animation_finished
		if attack_zone.overlaps_body(player) and player != null:
			player.take_damage(int(damage))
	is_attacking = false
	attack_cooldown = ATTACK_DELAY
	if player == null:
		current_state = State.IDLE
	elif attack_zone.overlaps_body(player):
		can_attack = true
		current_state = State.ATTACK
	else:
		can_attack = false
		current_state = State.CHASE

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
	is_attacking = false
	current_state = State.STUN
	var direction = (global_position - from_position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.LEFT
	velocity.x = direction.x * knockback_force
	sprite.play("hurt")
	await sprite.animation_finished
	is_stunned = false
	if player == null:
		current_state = State.IDLE
	elif attack_zone.overlaps_body(player):
		can_attack = true
		current_state = State.ATTACK
	else:
		current_state = State.CHASE
func die():
	if is_dying:
		return
	is_dying = true
	sprite.play("Die")
	set_physics_process(false)
	await get_tree().create_timer(1).timeout
	var scene = get_tree().current_scene.scene_file_path
	queue_free()
