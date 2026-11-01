extends Area2D
## Boss projectile: flies in a straight line toward where the player WAS when it was fired.

@export var speed: float = 220.0   # slow enough to dodge; the first thing to tune
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	# Connecting in code means no editor signal setup is needed
	body_entered.connect(_on_body_entered)

func setup(direction: Vector2) -> void:
	velocity = direction.normalized() * speed

func _physics_process(delta: float) -> void:
	position += velocity * delta
	# Free the bullet once it is well off-screen so they don't pile up
	if not get_viewport_rect().grow(100.0).has_point(global_position):
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.die()          # same call enemy.gd uses
		queue_free()

func _draw() -> void:       # placeholder visual; swap for a Sprite2D later
	draw_circle(Vector2.ZERO, 10.0, Color(1.0, 0.3, 0.3))
	draw_circle(Vector2.ZERO, 5.0, Color.WHITE)
