extends Area2D

@export var speed: float = 160.0
@export var hp: int = 3

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	# Despawn if it moves past the bottom of the screen
	if position.y > get_viewport_rect().size.y + 60.0:
		queue_free()

func take_damage(amount: int = 1) -> void:
	hp -= amount
	# Hit flash juice: flash red briefly on impact
	modulate = Color(1.0, 0.3, 0.3)
	await get_tree().create_timer(0.06).timeout
	modulate = Color(1.0, 1.0, 1.0)

	if hp <= 0:
		queue_free()
