extends CanvasLayer

var score_label: Label
var level_label: Label
var boss_label: Label
var boss_bar: ProgressBar

func _ready() -> void:
	layer = 10   # draws above the game

	var row := HBoxContainer.new()
	add_child(row)
	row.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	row.offset_left = 16.0
	row.offset_right = -16.0
	row.offset_top = 12.0

	score_label = UIKit.label("SCORE  0", 22)
	score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	score_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(score_label)

	level_label = UIKit.label("", 22)
	level_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(level_label)

	var boss_box := VBoxContainer.new()
	boss_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(boss_box)

	boss_label = UIKit.label("BOSS IN", 16)
	boss_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	boss_box.add_child(boss_label)

	boss_bar = ProgressBar.new()
	boss_bar.max_value = 1.0
	boss_bar.show_percentage = false
	boss_bar.custom_minimum_size = Vector2(0, 14)
	boss_box.add_child(boss_bar)

	score_label.text = "SCORE  %d" % Score.score
	Score.score_changed.connect(_on_score_changed)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "SCORE  %d" % new_score

func set_level(text: String) -> void:
	level_label.text = text

func set_boss_progress(ratio: float) -> void:
	boss_bar.value = clampf(ratio, 0.0, 1.0)
	boss_label.text = "BOSS INCOMING" if ratio >= 1.0 else "BOSS IN"

func show_boss_fight() -> void:
	boss_bar.value = 1.0
	boss_label.text = "BOSS FIGHT!"
