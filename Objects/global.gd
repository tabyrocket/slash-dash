extends Node

var score: int = 0
var is_game_over = false

func reset():
	score = 0
	is_game_over = false
	Bgm.pitch_scale = 1
	Bgm.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset") and get_tree().current_scene.name in ["MainLevel"]:
		reset()
		get_tree().change_scene_to_file("res://Levels/main_level.tscn")
	
	if Input.is_action_just_pressed("home"):
		get_tree().change_scene_to_file("res://Levels/main_menu.tscn")

func add_score():
	score += 1
	Bgm.pitch_scale = 1 + (int(score/10) * 0.25)

func game_over():
	if not is_game_over:
		Bgm.pitch_scale = 0.5
		is_game_over = true
		print("Score: ", score)
