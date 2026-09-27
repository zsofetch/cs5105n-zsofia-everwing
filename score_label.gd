extends Label

func _ready() -> void:
	Score.score_changed.connect(_on_score_changed)
	text = "Score: 0"

func _on_score_changed(new_score: int) -> void:
	text = "Score: %d" % new_score
