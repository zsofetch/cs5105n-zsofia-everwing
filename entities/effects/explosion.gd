extends CPUParticles2D

# Configured in code so the effect is easy to read and tweak.
func _ready() -> void:
	one_shot = true
	amount = 18
	lifetime = 0.6
	explosiveness = 1.0          # all particles burst at once
	direction = Vector2.UP
	spread = 180.0               # 180 either side = a full circle
	gravity = Vector2.ZERO
	initial_velocity_min = 90.0
	initial_velocity_max = 260.0
	scale_amount_min = 4.0       # no texture, so these are square sizes in pixels
	scale_amount_max = 8.0

	# Fade from yellow to transparent red over the particle's life
	var fade := Gradient.new()
	fade.set_color(0, Color(1.0, 0.9, 0.3, 1.0))
	fade.set_color(1, Color(1.0, 0.2, 0.2, 0.0))
	color_ramp = fade

	finished.connect(queue_free)  # clean itself up when done
	restart()
