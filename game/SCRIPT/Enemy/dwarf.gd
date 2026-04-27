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
@export var health = 10
@export var knockback_force = 100
@export var stun_duration = 0.5

var current_state = State.IDLE
var player = null
var can_attack = false
var is_attacking = false
var is_stunned = false
var is_dying = false
var damage = 2
var knockback_velocity = Vector2.ZERO
var attack_cooldown: float = 0.0
const ATTACK_DELAY: float = 0.5

@onready var lft: CollisionShape2D = $CollisionShape2D_left
@onready var rgt: CollisionShape2D = $CollisionShape2D_right
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_zone: Area2D = $Attackzone
@onready var detection: Area2D = $DetectionZone
@onready var floor_check_lft: RayCast2D = $FloorCheck
@onready var floor_check_rgt: RayCast2D = $FloorCheck2

func _ready() -> void:
	detection.body_entered.connect(_on_detection_entered)
	detection.body_exited.connect(_on_detection_exited)
	attack_zone.body_entered.connect(_on_attack_zone_entered)
	attack_zone.body_exited.connect(_on_attack_zone_exited)
	var scene = get_tree().current_scene.scene_file_path
	if scene == "res://SCENE/workd/world7.tscn":
		health = 80
		damage = 13
	elif scene == "res://SCENE/workd/world8.tscn":
		health = 110
		damage = 16
	elif scene == "res://SCENE/workd/world9.tscn":
		health = 140
		damage = 20
func _on_detection_entered(body):
	if body is Player:
		player = body
		if current_state == State.IDLE:
			current_state = State.CHASE

func _on_detection_exited(body):
	if body is Player:
		player = null
		current_state = State.IDLE

func _on_attack_zone_entered(body):
	if body is Player:
		can_attack = true
		if not is_stunned and not is_attacking:
			current_state = State.ATTACK

func _on_attack_zone_exited(body):
	if body is Player:
		if not is_stunned:
			can_attack = false
			if not is_attacking:
				current_state = State.CHASE

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
	var can_move = false
	if direction < 0:
		can_move = floor_check_lft.is_colliding()
	else:
		can_move = floor_check_rgt.is_colliding()
	if not can_move:
		velocity.x = 0
		return
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
	if is_attacking or attack_cooldown > 0:
		return
	is_attacking = true
	velocity.x = 0
	sprite.play("attack")
	await sprite.animation_finished
	if attack_zone.overlaps_body(player) and player != null:
		player.take_damage(damage)
		can_attack = true
	is_attacking = false
	attack_cooldown = ATTACK_DELAY
	if player == null:
		current_state = State.IDLE
	elif attack_zone.overlaps_body(player):
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
	velocity = direction * knockback_force
	sprite.play("hurt")
	await get_tree().create_timer(0.35).timeout
	get_tree().paused = true
	await get_tree().create_timer(0.12).timeout
	get_tree().paused = false
	await get_tree().create_timer(stun_duration).timeout
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
	if scene == "res://SCENE/workd/world7.tscn":
		GameState.Coin += 25
		GameState.Kill += 10
		GameState.Crystal+=10
	elif scene == "res://SCENE/workd/world8.tscn":
		GameState.Coin += 35
		GameState.Kill += 13
		GameState.Crystal+=15
	elif scene == "res://SCENE/workd/world8.tscn":
		GameState.Coin += 45
		GameState.Kill += 15
		GameState.Crystal+=22
	if scene == "res://SCENE/workd/world7.tscn":
		await get_tree().create_timer(0.5).timeout
		GameState.dwarf_killed = true
		get_tree().change_scene_to_file("res://SCENE/levels.tscn")
	if scene == "res://SCENE/workd/world8.tscn":
		await get_tree().create_timer(0.5).timeout
		GameState.dwarf_killed2 = true
		get_tree().change_scene_to_file("res://SCENE/levels.tscn")
	if scene == "res://SCENE/workd/world9.tscn":
		await get_tree().create_timer(0.5).timeout
		GameState.dwarf_killed3 = true
		get_tree().change_scene_to_file("res://SCENE/levels.tscn")
	else:
		queue_free()
		
