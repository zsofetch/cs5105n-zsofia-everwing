extends Parallax2D

@export var scroll_speed: float = 250.0

func _process(delta: float) -> void:
	scroll_offset.y += scroll_speed * delta
	if repeat_size.y > 0 and scroll_offset.y >= repeat_size.y:
		scroll_offset.y = fmod(scroll_offset.y, repeat_size.y)
