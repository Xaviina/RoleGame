extends Node

const PLAYER_SCENE = preload("res://Player/Scenes/Player.tscn")

var player = null

func spawn_player(spawn_point: Marker2D):
	if not spawn_point:
		push_error("SpawnPoint not found!")
		return
	# alten Player löschen
	if player:
		player.queue_free()

	# neuen Player erstellen
	player = PLAYER_SCENE.instantiate()
	PlayerManager.player = player

	# direkt in die aktuelle Szene einfügen
	get_tree().current_scene.call_deferred("add_child", player)

	# Position des SpawnPoints übernehmen
	player.global_position = spawn_point.global_position
