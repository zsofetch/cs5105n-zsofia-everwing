extends Node
## Saves progress to user://save.json and loads it on launch.

const SAVE_PATH := "user://save.json"

var high_score: int = 0
var has_progress: bool = false   # is there a run to Continue?
var saved_level: int = 0         # level to resume at
var saved_score: int = 0         # score to resume with
var continuing: bool = false     # set by the Continue button, consumed by game.gd

func _ready() -> void:
	load_game()

func save_game() -> void:
	var data := {
		"high_score": high_score,
		"has_progress": has_progress,
		"level": saved_level,
		"score": saved_score,
	}
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_warning("Could not write save file")
		return
	f.store_string(JSON.stringify(data))

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	if typeof(parsed) != TYPE_DICTIONARY:
		return   # corrupt or empty file: ignore it instead of crashing
	high_score = int(parsed.get("high_score", 0))
	has_progress = bool(parsed.get("has_progress", false))
	saved_level = int(parsed.get("level", 0))
	saved_score = int(parsed.get("score", 0))

# Call when the player beats a level
func checkpoint(next_level: int, score: int) -> void:
	has_progress = true
	saved_level = next_level
	saved_score = score
	submit_score(score)   # also saves

# Call when a run ends (death or win)
func submit_score(score: int) -> void:
	if score > high_score:
		high_score = score
	save_game()

# Call when the whole game is completed
func clear_progress() -> void:
	has_progress = false
	saved_level = 0
	saved_score = 0
	save_game()
