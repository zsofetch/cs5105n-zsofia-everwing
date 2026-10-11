extends Control

const GAME_SCENE = "res://levels/game.tscn"
const BACKGROUND = preload("res://assets/art/corridor.jpg")

var preview: TextureRect
var name_label: Label
var colorblind_button: Button
var swatches: Array[ColorRect] = []

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := TextureRect.new()
	bg.texture = BACKGROUND
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.6)
	add_child(dim)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 18)
	center.add_child(box)

	box.add_child(UIKit.label("EVERWING", 64))
	box.add_child(UIKit.label("CHOOSE YOUR CHARACTER", 20))

	# Character picker:  <  [portrait]  >
	var picker := HBoxContainer.new()
	picker.alignment = BoxContainer.ALIGNMENT_CENTER
	picker.add_theme_constant_override("separation", 20)
	box.add_child(picker)
	picker.add_child(UIKit.button("<", _on_prev, Vector2(64, 64)))
	preview = TextureRect.new()
	preview.custom_minimum_size = Vector2(128, 128)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	picker.add_child(preview)
	picker.add_child(UIKit.button(">", _on_next, Vector2(64, 64)))

	name_label = UIKit.label("", 28)
	box.add_child(name_label)

	var start := UIKit.button("START", _on_start)
	box.add_child(start)

	# Accessibility: colorblind-safe palette toggle + live preview of the health-bar colours
	colorblind_button = UIKit.button("", _on_colorblind_pressed)
	box.add_child(colorblind_button)
	var swatch_row := HBoxContainer.new()
	swatch_row.alignment = BoxContainer.ALIGNMENT_CENTER
	swatch_row.add_theme_constant_override("separation", 8)
	box.add_child(swatch_row)
	for i in range(3):
		var s := ColorRect.new()
		s.custom_minimum_size = Vector2(56, 14)
		swatch_row.add_child(s)
		swatches.append(s)

	box.add_child(UIKit.button("QUIT", _on_quit))

	_refresh_character()
	_refresh_colorblind()
	AudioManager.play_music("bgm")
	start.grab_focus()

func _on_prev() -> void:
	GameState.selected = wrapi(GameState.selected - 1, 0, GameState.CHARACTERS.size())
	_refresh_character()

func _on_next() -> void:
	GameState.selected = wrapi(GameState.selected + 1, 0, GameState.CHARACTERS.size())
	_refresh_character()

func _refresh_character() -> void:
	var c = GameState.CHARACTERS[GameState.selected]
	preview.texture = c["texture"]
	name_label.text = c["name"]

func _on_colorblind_pressed() -> void:
	GameState.set_colorblind_mode(not GameState.colorblind_mode)
	_refresh_colorblind()

func _refresh_colorblind() -> void:
	colorblind_button.text = "COLORBLIND: " + ("ON" if GameState.colorblind_mode else "OFF")
	swatches[0].color = GameState.hp_color(1.0)   # full health
	swatches[1].color = GameState.hp_color(0.5)   # half health
	swatches[2].color = GameState.hp_color(0.2)   # nearly dead

func _on_start() -> void:
	get_tree().change_scene_to_file(GAME_SCENE)

func _on_quit() -> void:
	get_tree().quit()
