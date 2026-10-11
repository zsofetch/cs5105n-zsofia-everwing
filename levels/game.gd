extends Node2D

const ENEMY_SCENE = preload("res://entities/enemies/enemy.tscn")
const BOSS_SCENE = preload("res://entities/boss/boss.tscn")
const HUD_SCENE = preload("res://ui/hud/hud.tscn")
const GAME_OVER_SCENE = preload("res://ui/game_over/game_over.tscn")
const MAIN_MENU = "res://ui/main_menu/main_menu.tscn"

const LANE_COUNT: int = 5

# One entry per level. Edit these numbers to tune the difficulty.
const LEVELS = [
	{
		"name": "LEVEL 1",
		"mob_speed": 90.0,
		"mob_hp": 2,
		"mobs_per_wave": 2,
		"wave_gap": 0.4,
		"boss_delay": 30.0,
		"boss_hp": 30,
	},
	{
		"name": "LEVEL 2",
		"mob_speed": 130.0,
		"mob_hp": 3,
		"mobs_per_wave": 3,
		"wave_gap": 0.33,
		"boss_delay": 40.0,
		"boss_hp": 50,
	},
]

@export var current_level: int = 1

@onready var spawner: Timer = $EnemySpawner

var cfg: Dictionary
var hud: CanvasLayer
var lane_positions: Array[float] = []
var level_timer: float = 0.0
var boss_active: bool = false
var boss_incoming: bool = false
var is_game_over: bool = false
var is_transitioning: bool = false

var current_wave_mobs: Array = []
var wave_kill_count: int = 0

func _ready() -> void:
	Score.reset()
	AudioManager.play_music("bgm")               # NEW
	hud = HUD_SCENE.instantiate()
	add_child(hud)
	_setup_lanes()
	_load_level(current_level)
	spawner.wait_time = 0.25
	spawner.timeout.connect(_check_spawn_wave)
	spawner.start()

	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.died.connect(_on_player_died)

func _process(delta: float) -> void:
	if boss_active or is_game_over or is_transitioning:
		return
	level_timer += delta
	var delay: float = cfg["boss_delay"]
	hud.set_boss_progress(level_timer / delay)
	if not boss_incoming and level_timer >= delay:
		boss_incoming = true

func _load_level(level: int) -> void:
	current_level = level
	cfg = LEVELS[level - 1]
	level_timer = 0.0
	boss_active = false
	boss_incoming = false
	is_transitioning = false
	hud.set_level(cfg["name"])
	hud.set_boss_progress(0.0)

func _setup_lanes() -> void:
	var screen_w: float = get_viewport_rect().size.x
	var margin: float = 60.0
	var usable_width: float = screen_w - margin * 2.0
	lane_positions.clear()
	for i in range(LANE_COUNT):
		var t: float = float(i) / float(LANE_COUNT - 1) if LANE_COUNT > 1 else 0.5
		lane_positions.append(margin + usable_width * t)

# Speed creeps from 100% to 125% over the level.
func _ramp() -> float:
	var delay: float = cfg["boss_delay"]
	return lerpf(1.0, 1.25, clampf(level_timer / delay, 0.0, 1.0))

func _check_spawn_wave() -> void:
	if is_game_over or is_transitioning:
		return
	if boss_incoming and not boss_active and get_tree().get_nodes_in_group("mobs").is_empty():
		_spawn_boss()
		return
	if boss_active or boss_incoming:
		return

	var mobs := get_tree().get_nodes_in_group("mobs")
	var min_y: float = 1e6
	for m in mobs:
		min_y = min(min_y, m.position.y)

	var screen_h: float = get_viewport_rect().size.y
	var gap: float = cfg["wave_gap"]
	if mobs.is_empty() or min_y > screen_h * gap:
		_spawn_wave()

func _spawn_wave() -> void:
	current_wave_mobs.clear()
	wave_kill_count = 0
	var lanes := lane_positions.duplicate()
	lanes.shuffle()
	var count: int = mini(cfg["mobs_per_wave"], LANE_COUNT - 1)
	for i in range(count):
		var enemy = ENEMY_SCENE.instantiate()
		enemy.speed = float(cfg["mob_speed"]) * _ramp()
		enemy.max_hp = cfg["mob_hp"]
		enemy.position = Vector2(lanes[i], -50.0)
		enemy.died.connect(_on_wave_mob_died)
		add_child(enemy)
		current_wave_mobs.append(enemy)

func _on_wave_mob_died() -> void:
	wave_kill_count += 1
	if wave_kill_count >= current_wave_mobs.size():
		Score.add_points(5)

func _spawn_boss() -> void:
	boss_active = true
	AudioManager.play_sfx("boss_appear")         # NEW
	hud.show_boss_fight()
	var boss = BOSS_SCENE.instantiate()
	boss.max_hp = cfg["boss_hp"]
	boss.position = Vector2(get_viewport_rect().size.x / 2.0, -120.0)
	boss.boss_defeated.connect(_on_boss_defeated)
	add_child(boss)

func _on_boss_defeated() -> void:
	boss_active = false
	is_transitioning = true
	if current_level >= LEVELS.size():
		await _show_banner("YOU WIN!", 3.0)
		get_tree().change_scene_to_file(MAIN_MENU)
		return
	await _show_banner("%s COMPLETE" % cfg["name"], 2.0)
	if is_game_over:
		return
	_load_level(current_level + 1)
	_show_banner(cfg["name"], 1.5)

func _on_player_died() -> void:
	if is_game_over:
		return
	is_game_over = true
	spawner.stop()
	await get_tree().create_timer(0.8).timeout   # let the hit sink in
	var screen = GAME_OVER_SCENE.instantiate()
	add_child(screen)
	screen.setup(Score.score)

func _show_banner(text: String, duration: float = 0.0) -> void:
	var layer := CanvasLayer.new()
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 56)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	layer.add_child(label)
	add_child(layer)
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	if duration > 0.0:
		await get_tree().create_timer(duration).timeout
		layer.queue_free()
