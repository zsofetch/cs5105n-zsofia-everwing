extends Area2D

@export var speed: float = 850.0

func _physics_process(delta: float) -> void:
	position.y -= speed * delta
	if position.y < -50.0:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("take_damage"):
		area.take_damage(1)
		queue_free()
