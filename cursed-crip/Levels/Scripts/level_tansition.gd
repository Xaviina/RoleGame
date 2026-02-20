@tool
extends Area2D
class_name LevelTransition

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file("*.tscn") var level_scene_path: String
@export var target_spawn: String = "SpawnStart"
@export var lock_duration: float = 1.5

@export_category("Collision Area Settings")

@export_range(1, 12, 1, "or_greater") var size: int = 2 :
	set(_v): 
		size = _v 
		_update_area()
		
@export var side: SIDE = SIDE.LEFT :
	set(_v): 
		side = _v
		_update_area()
		
@export var snap_to_grid: bool = false :
	set(_v): 
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var transition_locked := false

func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	body_entered.connect(_player_entered)

func _player_entered(_p: Node2D) -> void:
	if transition_locked or not level_scene_path:
		return

	transition_locked = true  # Transition sperren, während Player in der Area ist

	# Level laden
	var game_controller = get_tree().root.get_node("Main/GameController")
	var level_scene = load(level_scene_path) as PackedScene
	if level_scene:
		await game_controller.load_level(level_scene)

func _player_exited(_p: Node2D) -> void:
	# Sobald der Player die Area verlässt, wieder freigeben
	transition_locked = false
	
# --- Area Größe anpassen ---
func _update_area() -> void:
	var new_rect = Vector2(170, 170)
	var new_position = Vector2.ZERO

	match side:
		SIDE.TOP:
			new_rect.x *= size
			new_position.y -= 85
		SIDE.BOTTOM:
			new_rect.x *= size
			new_position.y += 85
		SIDE.LEFT:
			new_rect.y *= size
			new_position.x -= 85
		SIDE.RIGHT:
			new_rect.y *= size
			new_position.x += 85

	if collision_shape:
		collision_shape.shape.size = new_rect
		collision_shape.position = new_position

func _snap_to_grid() -> void:
	position.x = round(position.x / 85) * 85
	position.y = round(position.y / 85) * 85
