class_name UIKit
extends RefCounted

static func label(text: String, size: int = 24) -> Label:
	var l := Label.new()
	l.text = text
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.add_theme_font_size_override("font_size", size)
	# Dark outline keeps text readable over any background
	l.add_theme_constant_override("outline_size", maxi(2, int(size / 8.0)))
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	return l

static func button(text: String, on_pressed: Callable, min_size: Vector2 = Vector2(260, 56)) -> Button:
	var b := Button.new()
	b.text = text
	b.custom_minimum_size = min_size
	b.add_theme_font_size_override("font_size", 24)
	b.pressed.connect(func(): AudioManager.play_sfx("click"))
	b.pressed.connect(on_pressed)
	return b
