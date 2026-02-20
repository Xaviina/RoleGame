extends Node

var transition_locked := false
var transition_lock_time := 1.5

func load_new_level(level_scene: PackedScene, spawn_name: String) -> void:
	if transition_locked:
		return
	transition_locked = true
	get_tree().paused = true

	var main = get_tree().root.get_node("Main")

	# Node-Name aus PackedScene ermitteln
	var node_name = level_scene.resource_path.get_file().get_basename()
	var target_level = main.level_container.get_node_or_null(node_name)

	if target_level == null:
		# Instanzieren, falls Level noch nicht im LevelContainer
		target_level = level_scene.instantiate()
		target_level.name = node_name
		main.level_container.add_child(target_level)

	# Alle Levels deaktivieren
	for child in main.level_container.get_children():
		main._set_level_active(child, false)

	# Ziel-Level aktivieren
	main._set_level_active(target_level, true)

	# Spieler an Spawnpunkt setzen
	if main.player:
		var spawn = target_level.get_node_or_null(spawn_name)
		if spawn:
			main.player.global_position = spawn.global_position

	# Player-Signale aktualisieren
	main._setup_player_signals()

	await get_tree().process_frame
	get_tree().paused = false
	await get_tree().create_timer(transition_lock_time).timeout
	transition_locked = false
