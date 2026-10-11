extends Area2D

signal boss_defeated

@export var speed: float = 80.0
@export var max_hp: int = 40
@export var stop_y: float = 160.0

var hp: int
var has_stopped: bool = false

const BAR_WIDTH: float = 140.0
const BAR_HEIGHT: float = 10.0
const BAR_OFFSET_Y: float = -90.0

func _ready() -> void:
	hp = max_hp
	add_to_group("boss")
	queue_redraw()

func _physics_process(delta: float) -> void:
	if not has_stopped:
		position.y += speed * delta
		if position.y >= stop_y:
			position.y = stop_y
			has_stopped = true

func take_damage(amount: int = 1) -> void:
	hp -= amount
	modulate = Color(1.0, 0.4, 0.4)
	queue_redraw()
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(self):
		modulate = Color(1.0, 1.0, 1.0)
	if hp <= 0:
		boss_defeated.emit()
		queue_free()

func _draw() -> void:
	var pct: float = float(hp) / float(max_hp)
	var bg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(BAR_WIDTH, BAR_HEIGHT))
	draw_rect(bg, Color(0.1, 0.1, 0.1, 0.9))
	var fill_w: float = BAR_WIDTH * clamp(pct, 0.0, 1.0)
	var fg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(fill_w, BAR_HEIGHT))
	draw_rect(fg, Color(0.8, 0.1, 0.5))
