extends Control

var is_fullscreen = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/instructions.tscn")


func _on_fullscreen_pressed() -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		is_fullscreen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		is_fullscreen = true


func _on_exit_pressed() -> void:
	get_tree().quit()
