extends Node2D

const ENEMY_SCENE = preload("res://enemy.tscn")
@onready var spawner: Timer = $EnemySpawner

func _ready() -> void:
	spawner.timeout.connect(_on_spawner_timeout)

func _on_spawner_timeout() -> void:
	var enemy = ENEMY_SCENE.instantiate()
	var screen_w: float = get_viewport_rect().size.x
	# Spawn across the corridor width, just above the top boundary
	enemy.position = Vector2(randf_range(60.0, screen_w - 60.0), -50.0)
	add_child(enemy)
