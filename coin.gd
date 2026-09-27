extends Area2D

@export var initial_fall_speed: float = 60.0
@export var fall_gravity: float = 980.0
@export var max_fall_speed: float = 500.0
@export var value: int = 1
@export var textures: Array[Texture2D] = []
@export var target_size: Vector2 = Vector2(32.0, 32.0)
@export var spin_speed: float = 2.5

@onready var sprite: Sprite2D = $Sprite2D

var fall_velocity: float = 0.0

func _ready() -> void:
	add_to_group("coins")
	body_entered.connect(_on_body_entered)
	fall_velocity = initial_fall_speed
	if textures.size() > 0:
		var tex: Texture2D = textures[randi() % textures.size()]
		sprite.texture = tex
		_fit_sprite_to_target_size(tex)

func _fit_sprite_to_target_size(tex: Texture2D) -> void:
	var tex_size: Vector2 = tex.get_size()
	if tex_size.x <= 0.0 or tex_size.y <= 0.0:
		return
	var scale_factor: float = min(target_size.x / tex_size.x, target_size.y / tex_size.y)
	sprite.scale = Vector2(scale_factor, scale_factor)

func _physics_process(delta: float) -> void:
	fall_velocity = min(fall_velocity + gravity * delta, max_fall_speed)
	position.y += fall_velocity * delta
	sprite.rotation += spin_speed * delta
	if position.y > get_viewport_rect().size.y + 60.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Score.add_points(value)
		queue_free()
