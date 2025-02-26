extends Node2D

@onready var camera: Camera2D = $Player/Camera2D
var skenemy = preload("res://Objects/skenemy.tscn")
@onready var player: CharacterBody2D = $Player

@onready var firstskenny: CharacterBody2D = $Skenemy
@onready var enemies = [firstskenny]
#@export var enemy_cap = 100
var game_over = false

@onready var spawn_timer: Timer = $SpawnTimer
var spawn_count = 1

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test"):
		spawn()

func spawn():
	spawn_count = min(int(Global.score / 10) + 1, 3)
	for i in spawn_count:
		var skelly = skenemy.instantiate()
		enemies.append(skelly)
		skelly.target = player
		skelly.global_position = get_random_position()
		add_child(skelly)

func end():
	game_over = true
	for ene in enemies:
		ene.passive = true
		ene.hitbox.monitoring = false

func get_random_position():
	var vpr = (get_viewport_rect().size / camera.zoom) * randf_range(1.1, 1.4)
	var top_left = Vector2(camera.global_position.x - vpr.x/2, camera.global_position.y - vpr.y/2)
	var top_right = Vector2(camera.global_position.x + vpr.x/2, camera.global_position.y - vpr.y/2)
	var bottom_left = Vector2(camera.global_position.x - vpr.x/2, camera.global_position.y + vpr.y/2)
	var bottom_right = Vector2(camera.global_position.x + vpr.x/2, camera.global_position.y + vpr.y/2)
	var pos_side = ["up", "down", "left", "right"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right

	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)


func _on_spawn_timer_timeout() -> void:
	var levels = int(Global.score / 5)
	spawn_timer.wait_time = max(4 * (0.9**levels), 2)
	if not game_over:
		spawn()
