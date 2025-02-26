extends CanvasLayer

@onready var score_label: Label = $ScoreLabel
@onready var restart_label: Label = $RestartLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_score_label():
	score_label.text = str(Global.score)

func game_over():
	restart_label.visible = true
