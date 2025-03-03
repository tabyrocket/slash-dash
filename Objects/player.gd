extends CharacterBody2D

@export var speed = 800
@export var dash_speed = 3000

@onready var dash_time: Timer = $Timers/DashTime
@onready var dash_cooldown: Timer = $Timers/DashCooldown
@onready var dash_sound: AudioStreamPlayer = $Sounds/DashSound

@onready var melee_cooldown: Timer = $Timers/MeleeCooldown
@onready var sword_attack: Area2D = $AnimatedSprite2D/SwordAttack
@onready var attack_sound: AudioStreamPlayer = $Sounds/AttackSound

@onready var death_sound: AudioStreamPlayer = $Sounds/DeathSound

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var hud: CanvasLayer = $"../HUD"
@onready var end_timer: Timer = $Timers/EndTimer

@onready var gpu_particles: GPUParticles2D = $GPUParticles2D

enum States { Idle, Move, Dash, Death, Attack }
var state = States.Idle
var dash_ready = true
var attack_ready = true

var input_direction = Vector2.ZERO

func no_move_input():
	return input_direction == Vector2.ZERO

func ready():
	return state in [States.Idle, States.Move, States.Attack]

func hit_check():
	if sword_attack.monitoring == true:
		for area in sword_attack.get_overlapping_areas():
			area.get_parent().die()
			sword_attack.monitoring = false
			break

func _physics_process(delta: float) -> void:
	reset_attack()
	hit_check()
	input_direction = Input.get_vector("left", "right", "up", "down")
	
	if ready():
		velocity = input_direction * speed
		if state != States.Attack:
			if no_move_input():
				state = States.Idle
				sprite.animation = "idle"
				sprite.play()
			else:
				state = States.Move
				sprite.animation = "walk"
				sprite.play()
				if input_direction.x < 0:
					sprite.scale.x = -2.4
				else:
					sprite.scale.x = abs(sprite.scale.x)
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	#if Input.is_action_just_pressed("dash"):
	#	dash()
	
	if Input.get_action_strength("dash") != 0:
		dash()

	move_and_slide()

func reset_attack():
	if animation_player.current_animation == "" and state == States.Attack:
		state = States.Idle

func attack():
	if ready() and attack_ready:
		state = States.Attack
		sprite.animation = "attack"
		sprite.play()
		attack_sound.play()
		attack_ready = false
		#attacklogic
		animation_player.current_animation = "attack"
		animation_player.play()
		melee_cooldown.start()

func dash():
	if ready() and dash_ready and not no_move_input():
		gpu_particles.emitting = false
		gpu_particles.emitting = true
		state = States.Dash
		sprite.animation = "dash"
		sprite.play()
		dash_sound.play()
		dash_ready = false
		velocity = input_direction * dash_speed
		dash_time.start()

func die():
	if state != States.Death:
		death_sound.play()
		velocity = Vector2.ZERO
		state = States.Death
		sprite.animation = "death"
		sprite.play()
		Global.game_over()
		end_timer.start()

func _on_dash_time_timeout() -> void:
	state = States.Idle
	sprite.animation = "idle"
	sprite.play()
	dash_cooldown.start()

func _on_dash_cooldown_timeout() -> void:
	dash_ready = true

func _on_melee_cooldown_timeout() -> void:
	attack_ready = true


func _on_end_timer_timeout() -> void:
	hud.game_over()
