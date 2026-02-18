extends Node

signal level_load_started
signal level_loaded
signal tilemap_bounds_changed (bounds:Array[Vector2])

var current_tilemap_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2

var transition_locked := false
var transition_lock_time := 1.5   # Sekunden (einstellbar)

func change_tilemap_bounds(bounds:Array[Vector2]) -> void:
	current_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)


func load_new_level(
		level_path: String,
		_target_transition : String,
		_posotion_offset: Vector2
) -> void:
	
	if transition_locked:
		return
		
	transition_locked = true
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _posotion_offset
	
	level_load_started.emit()
	
	await get_tree().process_frame # level transition
	
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame # level transition
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	 #  Cooldown starten
	await get_tree().create_timer(transition_lock_time).timeout
	transition_locked = false
	
	pass
