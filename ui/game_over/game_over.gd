extends CanvasLayer

const MAIN_MENU = "res://ui/main_menu/main_menu.tscn"

var score_label: Label

func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS   # keeps working while the game is paused
	get_tree().paused = true                  # freeze the game behind this screen

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.7)
	add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	center.add_child(box)

	box.add_child(UIKit.label("GAME OVER", 56))
	score_label = UIKit.label("SCORE  0", 28)
	box.add_child(score_label)
	var retry := UIKit.button("RETRY", _on_retry)
	box.add_child(retry)
	box.add_child(UIKit.button("MAIN MENU", _on_menu))
	retry.grab_focus()

func setup(final_score: int) -> void:
	score_label.text = "SCORE  %d" % final_score

func _on_retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(MAIN_MENU)
