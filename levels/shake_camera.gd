extends Camera2D
## Fixed top-left camera whose only job is to shake the screen.

var shake_strength: float = 0.0

func _ready() -> void:
	anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT  # behaves like "no camera"
	process_mode = Node.PROCESS_MODE_ALWAYS            # keeps working when the game over screen pauses
	position = Vector2.ZERO
	add_to_group("shake_camera")

func shake(strength: float = 8.0) -> void:
	shake_strength = max(shake_strength, strength)

func _process(delta: float) -> void:
	if shake_strength > 0.1:
		offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * shake_strength
		shake_strength = lerpf(shake_strength, 0.0, 10.0 * delta)
	else:
		shake_strength = 0.0
		offset = Vector2.ZERO
