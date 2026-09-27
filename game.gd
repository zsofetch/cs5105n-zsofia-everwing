extends Node2D

const ENEMY_SCENE = preload("res://enemy.tscn")
const BOSS_SCENE = preload("res://boss.tscn")

const LANE_COUNT: int = 5

@export var current_level: int = 1
@export var boss_spawn_delay: float = 30.0

@onready var spawner: Timer = $EnemySpawner

var lane_positions: Array[float] = []
var level_timer: float = 0.0
var boss_active: bool = false
var boss_incoming: bool = false

var current_wave_mobs: Array = []
var wave_kill_count: int = 0

func _ready() -> void:
	_setup_lanes()
	spawner.wait_time = 0.25
	spawner.timeout.connect(_check_spawn_wave)
	spawner.start()

func _process(delta: float) -> void:
	if boss_active:
		return
	level_timer += delta
	if not boss_incoming and level_timer >= boss_spawn_delay:
		boss_incoming = true

func _setup_lanes() -> void:
	var screen_w: float = get_viewport_rect().size.x
	var margin: float = 60.0
	var usable_width: float = screen_w - margin * 2.0
	lane_positions.clear()
	for i in range(LANE_COUNT):
		var t: float = float(i) / float(LANE_COUNT - 1) if LANE_COUNT > 1 else 0.5
		lane_positions.append(margin + usable_width * t)

func _mob_hp_for_level() -> int:
	return int(2 * pow(1.15, current_level - 1))

func _mob_speed_for_level() -> float:
	return 140.0 * pow(1.12, current_level - 1)

func _boss_hp_for_level() -> int:
	return int(40 * pow(1.35, current_level - 1))

func _check_spawn_wave() -> void:
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
	var gap_cleared: bool = mobs.is_empty() or min_y > screen_h * 0.35

	if gap_cleared:
		_spawn_wave()

func _spawn_wave() -> void:
	current_wave_mobs.clear()
	wave_kill_count = 0
	for x in lane_positions:
		var enemy = ENEMY_SCENE.instantiate()
		enemy.speed = _mob_speed_for_level()
		enemy.max_hp = _mob_hp_for_level()
		enemy.position = Vector2(x, -50.0)
		enemy.died.connect(_on_wave_mob_died)
		add_child(enemy)
		current_wave_mobs.append(enemy)

func _on_wave_mob_died() -> void:
	wave_kill_count += 1
	if wave_kill_count >= current_wave_mobs.size():
		Score.add_points(5)

func _spawn_boss() -> void:
	boss_active = true
	var boss = BOSS_SCENE.instantiate()
	boss.max_hp = _boss_hp_for_level()
	boss.position = Vector2(get_viewport_rect().size.x / 2.0, -120.0)
	boss.boss_defeated.connect(_on_boss_defeated)
	add_child(boss)

func _on_boss_defeated() -> void:
	boss_active = false
	boss_incoming = false
	level_timer = 0.0
	current_level += 1
