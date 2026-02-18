@tool
class_name LevelTransition extends Area2D

enum SIDE {LEFT, RIGHT, TOP, BOTTOM}

@export_file( "*.tscn" ) var level
@export var target_transition_area : String = "LevelTransition"

@export_category("Collision Area Settings")

@export_range(1, 12, 1, "or_greater") var size: int = 2

@export var side: SIDE = SIDE.LEFT

@export var snap_to_grid: bool = false

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	pass


func _update_area() -> void:
	var new_rect: Vector2 = Vector2(16, 16)
	var new_posotion: Vector2 = Vector2.ZERO
