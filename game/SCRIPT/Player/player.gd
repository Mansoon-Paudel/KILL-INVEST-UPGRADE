class_name Player
extends CharacterBody2D

const JUMP_VELOCITY = -450.0
const COYOTE_TIME = 0.13
const INVINCIBILITY_DURATION = 0.8
const FOOTSTEP_DELAY = 0.5
var dashing = false
var dash_timer = 0.0
var dash_direction = 0.0
const DASH_DURATION = 0.35
var coyote_timer = 0.0
var is_attacking = false
var is_dead = false
var is_invincible = false

var health = 0
var footstep_index = 0
var footstep_cooldown = 0.0

@onready var sprite2D: AnimatedSprite2D = $AnimatedSprite2D
@onready var footstep_player: AudioStreamPlayer = $"Footstep Stream"
@onready var attack_player: AudioStreamPlayer = $"Attack stream"
@onready var jump_player: AudioStreamPlayer = $"Jump stream"
@onready var player_attack: Area2D = $PlayerAttack
@onready var player: Player = $"."
@onready var rgt: CollisionShape2D = $PlayerAttack/CollisionShape2D_rgt
@onready var lft: CollisionShape2D = $PlayerAttack/CollisionShape2D_lft

const jmp = preload("res://ASSETS/SOUNDS/SFX/Player/jump.ogg")
const slice = preload("res://ASSETS/SOUNDS/SFX/Player/slice.wav")

const FOOTSTEP_SOUNDS = [
	preload("res://ASSETS/SOUNDS/SFX/Player/footstep00.ogg"),
	preload("res://ASSETS/SOUNDS/SFX/Player/footstep01.ogg"),
	preload("res://ASSETS/SOUNDS/SFX/Player/footstep02.ogg"),
	preload("res://ASSETS/SOUNDS/SFX/Player/footstep03.ogg"),
	preload("res://ASSETS/SOUNDS/SFX/Player/footstep04.ogg")
]

func _ready() -> void:
	player.position = GameState.player_position
	player_attack.monitoring = false
	player_attack.monitorable = false
	apply_upgrades()

func apply_upgrades() -> void:
	health = GameState.health

	if GameState.tier == 1:
		sprite2D.sprite_frames = preload("res://SCENE/Player/Tier_1.tres")
	elif GameState.tier == 2:
		sprite2D.sprite_frames = preload("res://SCENE/Player/Tier_2.tres")
	elif GameState.tier == 3:
		sprite2D.sprite_frames = preload("res://SCENE/Player/Tier_3.tres")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
		coyote_timer -= delta
	else:
		coyote_timer = COYOTE_TIME

	# Tick dash timer
	if dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			dashing = false
			dash_timer = 0.0

	if Input.is_action_just_pressed("Dash") and not dashing and not is_attacking:
		var dir := Input.get_axis("Left", "Right")
		if dir != 0:
			dashing = true
			dash_timer = DASH_DURATION
			dash_direction = dir

	if Input.is_action_just_pressed("Up"):
		if is_on_floor() or coyote_timer > 0.0:
			velocity.y = JUMP_VELOCITY
			coyote_timer = 0.0
			jump_player.stream = jmp
			jump_player.play()

	if Input.is_action_just_pressed("Attack") and not is_attacking:
		Start_attack()

	if not is_attacking:
		if dashing:
			velocity.x = dash_direction * GameState.Dash_Speed
		else:
			var direction := Input.get_axis("Left", "Right")
			if direction:
				velocity.x = direction * GameState.speed
			else:
				velocity.x = move_toward(velocity.x, 0, 18)
	else:
		velocity.x = move_toward(velocity.x, 0, 18)

	move_and_slide()
	UpdateAnimation()
	Handle_footsteps(delta)

func Handle_footsteps(delta: float) -> void:
	if is_on_floor() and abs(velocity.x) > 1 and not is_attacking:
		footstep_cooldown -= delta

		if not footstep_player.playing and footstep_cooldown <= 0.0:
			footstep_player.stream = FOOTSTEP_SOUNDS[footstep_index]
			footstep_player.play()
			footstep_index = (footstep_index + 1) % FOOTSTEP_SOUNDS.size()
			footstep_cooldown = FOOTSTEP_DELAY
	else:
		footstep_player.stop()
		footstep_cooldown = 0.0

func Start_attack() -> void:
	is_attacking = true
	player_attack.monitoring = true
	player_attack.monitorable = true

	sprite2D.play("Attack")

	await get_tree().create_timer(0.2).timeout
	attack_player.stream = slice
	attack_player.play()
	await get_tree().create_timer(0.1).timeout
	player_attack.monitoring = false
	player_attack.monitorable = false
	await sprite2D.animation_finished
	is_attacking = false

func take_damage(amount: int) -> void:
	if is_invincible or is_dead:
		return

	health -= amount
	print("Player health: ", health)

	if health <= 0:
		die()
		return

	is_invincible = true

	for i in range(4):
		sprite2D.modulate.a = 0.2
		await get_tree().create_timer(0.1).timeout
		sprite2D.modulate.a = 1.0
		await get_tree().create_timer(0.1).timeout

	await get_tree().create_timer(INVINCIBILITY_DURATION).timeout
	is_invincible = false

func die() -> void:
	if is_dead:
		return

	is_dead = true
	print("Player died")
	get_tree().reload_current_scene()
func UpdateAnimation() -> void:
	if velocity.x > 1:
		sprite2D.flip_h = false
		lft.disabled = true
		rgt.disabled = false
	elif velocity.x < -1:
		sprite2D.flip_h = true
		lft.disabled = false
		rgt.disabled = true

	if is_attacking:
		return

	if dashing:
		sprite2D.play("Dash")  
		return

	if not is_on_floor():
		sprite2D.play("Jump")
	elif abs(velocity.x) > 1:
		sprite2D.play("Left")
	else:
		sprite2D.play("Idle")
