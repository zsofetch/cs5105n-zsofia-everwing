extends Area2D

signal died

const COIN_SCENE = preload("res://entities/pickups/coin.tscn")
const EXPLOSION_SCENE = preload("res://entities/effects/explosion.tscn")

@export var speed: float = 140.0
@export var max_hp: int = 2
@export var textures: Array[Texture2D] = []
@export var target_size: Vector2 = Vector2(64.0, 64.0)

var hp: int
var is_dying: bool = false

@onready var sprite: Sprite2D = $Sprite2D

const BAR_WIDTH: float = 40.0
const BAR_HEIGHT: float = 5.0
const BAR_OFFSET_Y: float = -40.0

func _ready() -> void:
	hp = max_hp
	add_to_group("mobs")
	body_entered.connect(_on_body_entered)
	_apply_random_skin()
	queue_redraw()

func _apply_random_skin() -> void:
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
	position.y += speed * delta
	if position.y > get_viewport_rect().size.y + 60.0:
		queue_free()  # escaped off-screen: no coin, no "died" signal

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player") and body.has_method("die"):
		body.die()

func take_damage(amount: int = 1) -> void:
	if is_dying:
		return
	hp -= amount
	queue_redraw()
	if hp <= 0:
		is_dying = true
		_die.call_deferred()
		return
	AudioManager.play_sfx("hit", -4.0, 0.1)      # NEW
	modulate = Color(1.0, 0.3, 0.3)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(self):
		modulate = Color(1.0, 1.0, 1.0)

func _die() -> void:
	AudioManager.play_sfx("explosion", -2.0, 0.1)   # NEW
	_drop_coin()
	_spawn_explosion()
	died.emit()
	queue_free()

func _drop_coin() -> void:
	var coin = COIN_SCENE.instantiate()
	coin.global_position = global_position
	get_tree().current_scene.add_child(coin)

func _spawn_explosion() -> void:
	var fx = EXPLOSION_SCENE.instantiate()
	fx.global_position = global_position
	get_tree().current_scene.add_child(fx)

func _draw() -> void:
	var pct: float = float(hp) / float(max_hp)
	var bg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(BAR_WIDTH, BAR_HEIGHT))
	draw_rect(bg, Color(0.1, 0.1, 0.1, 0.85))
	var fill_w: float = BAR_WIDTH * clamp(pct, 0.0, 1.0)
	var fg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(fill_w, BAR_HEIGHT))
	draw_rect(fg, GameState.hp_color(pct))
