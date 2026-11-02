extends Area2D

signal boss_defeated

const BOSS_BULLET = preload("res://entities/bullets/boss_bullet.tscn")

# The boss is always in exactly ONE of these states
enum State { DESCEND, HOVER, AIM, FIRE }

@export var speed: float = 80.0          # descent speed
@export var max_hp: int = 40
@export var stop_y: float = 160.0
@export var hover_time: float = 1.8      # pause between attacks
@export var aim_time: float = 1.0        # how long the warning line shows
@export var shot_interval: float = 0.3   # seconds between shots in a burst
@export var burst_size: int = 2
@export var sway_amount: float = 50.0    # side-to-side sway distance (pixels)
@export var detect_range: float = 1400.0 # player must be within this to be attacked

var hp: int
var has_stopped: bool = false            # kept in case game.gd reads it
var is_dying: bool = false

var state: State = State.DESCEND
var state_time: float = 0.0              # seconds spent in the current state
var sway_clock: float = 0.0
var base_x: float = 0.0                  # x position the sway is centered on
var aim_dir: Vector2 = Vector2.DOWN      # direction locked in at the end of AIM
var shots_left: int = 0
var shot_timer: float = 0.0
var player: Node2D

const BAR_WIDTH: float = 140.0
const BAR_HEIGHT: float = 10.0
const BAR_OFFSET_Y: float = -90.0

func _ready() -> void:
	hp = max_hp
	add_to_group("boss")
	player = get_tree().get_first_node_in_group("player")
	queue_redraw()

func _physics_process(delta: float) -> void:
	if is_dying:
		return
	state_time += delta
	# Run the code for whichever state we're in
	match state:
		State.DESCEND:
			_state_descend(delta)
		State.HOVER:
			_state_hover()
		State.AIM:
			_state_aim()
		State.FIRE:
			_state_fire(delta)
	# Sway side to side once the boss has stopped descending
	if has_stopped:
		sway_clock += delta
		position.x = base_x + sin(sway_clock * 1.5) * sway_amount

# ---------- State machine ----------

func _change_state(new_state: State) -> void:
	state = new_state
	state_time = 0.0
	if new_state == State.FIRE:
		shots_left = _current_burst_size()
		shot_timer = 0.0
	queue_redraw()  # clears or shows the aim line

func _is_enraged() -> bool:
	# Phase 2: below half HP the boss gets more aggressive
	return hp <= max_hp / 2

func _current_burst_size() -> int:
	return burst_size + (2 if _is_enraged() else 0)

# Detection: is there a living player close enough to attack?
func _can_see_player() -> bool:
	if not is_instance_valid(player):
		return false
	if player.is_dead:
		return false
	return global_position.distance_to(player.global_position) <= detect_range

func _state_descend(delta: float) -> void:
	position.y += speed * delta
	if position.y >= stop_y:
		position.y = stop_y
		has_stopped = true
		base_x = position.x
		_change_state(State.HOVER)

func _state_hover() -> void:
	# Enraged boss waits less between attacks
	var wait: float = hover_time * (0.6 if _is_enraged() else 1.0)
	if state_time >= wait and _can_see_player():
		_change_state(State.AIM)

func _state_aim() -> void:
	queue_redraw()  # keeps the warning line following the player
	if state_time >= aim_time:
		_lock_aim()
		_change_state(State.FIRE)

func _state_fire(delta: float) -> void:
	shot_timer -= delta
	if shots_left > 0 and shot_timer <= 0.0:
		if _is_enraged():
			_lock_aim()  # enraged: re-aim before EVERY shot
		_shoot()
		shots_left -= 1
		shot_timer = shot_interval
	if shots_left <= 0:
		_change_state(State.HOVER)

# Remember where the player is RIGHT NOW. The bullet flies there, so
# a player who keeps moving can dodge it.
func _lock_aim() -> void:
	if is_instance_valid(player):
		aim_dir = (player.global_position - global_position).normalized()

func _shoot() -> void:
	var b = BOSS_BULLET.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position
	b.setup(aim_dir)
	AudioManager.play_sfx("shoot", -2.0, 0.1)  # placeholder until you pick a boss sound

# ---------- Damage (unchanged from your version) ----------

func take_damage(amount: int = 1) -> void:
	if is_dying:
		return
	hp -= amount
	modulate = Color(1.0, 0.4, 0.4)
	queue_redraw()
	if hp <= 0:
		is_dying = true
		Juice.shake(16.0)       # NEW
		Juice.hit_stop(0.12)    # NEW
		AudioManager.play_sfx("explosion")
		await get_tree().create_timer(0.06).timeout
		boss_defeated.emit()
		queue_free()
		return
	AudioManager.play_sfx("hit", -4.0, 0.1)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(self):
		modulate = Color(1.0, 1.0, 1.0)

# ---------- Drawing ----------

func _draw() -> void:
	# Health bar (unchanged)
	var pct: float = float(hp) / float(max_hp)
	var bg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(BAR_WIDTH, BAR_HEIGHT))
	draw_rect(bg, Color(0.1, 0.1, 0.1, 0.9))
	var fill_w: float = BAR_WIDTH * clamp(pct, 0.0, 1.0)
	var fg := Rect2(Vector2(-BAR_WIDTH / 2.0, BAR_OFFSET_Y), Vector2(fill_w, BAR_HEIGHT))
	draw_rect(fg, Color(0.8, 0.1, 0.5))

	# Warning line while aiming: pulses red toward the player
	if state == State.AIM and is_instance_valid(player):
		var dir: Vector2 = to_local(player.global_position).normalized()
		var alpha: float = 0.5 + 0.4 * sin(state_time * 30.0)
		draw_line(Vector2.ZERO, dir * 1500.0, Color(1.0, 0.2, 0.2, alpha), 3.0)
