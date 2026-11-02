extends Node
## Global feedback helpers: Juice.shake(...) and Juice.hit_stop(...)

func shake(strength: float = 8.0) -> void:
	var cam := get_tree().get_first_node_in_group("shake_camera")
	if cam:
		cam.shake(strength)

# Briefly slows the whole game to a near-freeze so a hit "lands"
func hit_stop(duration: float = 0.06, slow_scale: float = 0.05) -> void:
	if Engine.time_scale < 1.0:
		return  # already in a hit-stop
	Engine.time_scale = slow_scale
	# args: time, process_always, process_in_physics, ignore_time_scale
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.0
