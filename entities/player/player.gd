extends CharacterBody2D

signal died

@export var speed: float = 650.0
@export var fire_rate: float = 0.12
@export var tilt_angle: float = 0.3

const BULLET_SCENE = preload("res://entities/bullets/bullet.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var muzzle: Marker2D = $Muzzle
@onready var anim: AnimationPlayer = $AnimationPlayer

var shoot_timer: float = 0.0
var target_x: float = 0.0
var is_dragging: bool = false
var is_dead: bool = false

func _ready() -> void:
	target_x = position.x
	add_to_group("player")
	sprite.texture = GameState.get_character_texture()

func _input(event: InputEvent) -> void:
	if is_dead:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.pressed
			if is_dragging:
				target_x = event.position.x
	elif event is InputEventMouseMotion and is_dragging:
		target_x = event.position.x

func _physics_process(delta: float) -> void:
	var screen_width: float = get_viewport_rect().size.x

	# 1. Horizontal Motion (Mouse/Touch Drag + Keyboard Fallback)
	var keyboard_dir: float = Input.get_axis("move_left", "move_right")
	if keyboard_dir != 0.0:
		target_x += keyboard_dir * speed * delta

	target_x = clamp(target_x, 40.0, screen_width - 40.0)
	var move_diff: float = target_x - position.x
	velocity.x = move_diff * 15.0
	move_and_slide()

	# 2. Banking Tilt Juice based on horizontal speed
	var normalized_vel: float = clamp(velocity.x / speed, -1.0, 1.0)
	sprite.rotation = lerp_angle(sprite.rotation, normalized_vel * tilt_angle, 14.0 * delta)

	# 3. Pick the animation from the player's state
	var wanted: String = "move" if absf(velocity.x) > 100.0 else "idle"
	if anim.current_animation != wanted:
		anim.play(wanted)

	# 4. Continuous Auto-fire
	shoot_timer -= delta
	if shoot_timer <= 0.0:
		fire_bullet()
		shoot_timer = fire_rate

func fire_bullet() -> void:
	var bullet = BULLET_SCENE.instantiate()
	bullet.global_position = muzzle.global_position
	get_tree().current_scene.add_child(bullet)
	AudioManager.play_sfx("shoot", -8.0, 0.08)   # NEW (quiet and slightly varied: it plays constantly)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	AudioManager.play_sfx("player_death")        # NEW
	AudioManager.stop_music()                    # NEW
	died.emit()
	set_physics_process(false)
	hide()
