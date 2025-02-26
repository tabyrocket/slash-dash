extends CharacterBody2D

enum States { Idle, Move, Dash, Death, Attack }

@export var target: Node2D
@export var speed = 300
var attacking = false

@export var passive = false

@onready var hurtbox: Area2D = $Hurtbox
@onready var hitbox: Area2D = $Hitbox
var dead = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: AnimatedSprite2D = $Sprite

@onready var attack_sound: AudioStreamPlayer2D = $AttackSound
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

@onready var hud: CanvasLayer = $"../HUD"

func _ready() -> void:
	sprite.animation = "idle"

func hit_check():
	if hitbox.monitoring == true and target != null:
		if target in hitbox.get_overlapping_bodies() and target.state != States.Dash:
			#passive = true
			#hitbox.monitoring = false
			get_parent().end()
			target.die()
			#print("hit")

func _physics_process(delta: float) -> void:
	if not dead:
		do_a_flip()
		hit_check()
		if not attacking:
			if close_enough():
				if not passive:
					animation_player.current_animation = "attack"
					attack_sound.play()
					attacking = true
				else:
					sprite.animation = "idle"
			elif target == null:
				sprite.animation = "idle"
			else:
				sprite.animation = "walk"
				var move_direction = position.direction_to(target.position)
				velocity = move_direction * speed
				move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack" and not dead:
		attacking = false
		sprite.animation = "idle"

func close_enough():
	var y_diff = abs(target.position.y - position.y)
	var x_diff = abs(target.position.x - position.x)
	return y_diff < 70 and x_diff < 165

func do_a_flip():
	if target.position.x < position.x and scale.y > 0:
		scale.x = -5
	elif target.position.x > position.x and scale.y < 0:
		scale.x = -5

func die():
	sprite.animation = "death"
	hurtbox.monitorable = false
	hurtbox.monitoring = false
	speed = 0
	dead = true
	death_sound.play()
	Global.add_score()
	hud.update_score_label()
