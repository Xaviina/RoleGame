extends Node2D

func _ready():
	# Debug: Prüfen, ob SpawnPoint gefunden wird
	var spawn_point = $PlayerSpawn
	print("SpawnPoint:", spawn_point)
	PlayerManager.spawn_player(spawn_point)
	print("PlayerManager.player:", PlayerManager.player)
