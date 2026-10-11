extends Node

const SETTINGS_PATH = "user://settings.cfg"

# Add more characters here and they appear in the selector automatically.
const CHARACTERS = [
	{"name": "BOY", "texture": preload("res://assets/art/boy character.png")},
	{"name": "GIRL", "texture": preload("res://assets/art/girl character.png")},
]

var selected: int = 0
var colorblind_mode: bool = false

func _ready() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) == OK:
		colorblind_mode = cfg.get_value("accessibility", "colorblind_mode", false)

func get_character_texture() -> Texture2D:
	return CHARACTERS[selected]["texture"]

func set_colorblind_mode(on: bool) -> void:
	colorblind_mode = on
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH)   # keep any other settings already saved
	cfg.set_value("accessibility", "colorblind_mode", on)
	cfg.save(SETTINGS_PATH)

# Health-bar colour for the fraction of HP left (1.0 = full)
func hp_color(pct: float) -> Color:
	if colorblind_mode:
		# Okabe-Ito colorblind-safe palette: blue -> yellow -> vermilion
		if pct <= 0.3:
			return Color8(213, 94, 0)
		if pct <= 0.6:
			return Color8(240, 228, 66)
		return Color8(0, 114, 178)
	if pct <= 0.3:
		return Color(0.9, 0.2, 0.2)
	if pct <= 0.6:
		return Color(0.9, 0.9, 0.2)
	return Color(0.2, 0.9, 0.2)
