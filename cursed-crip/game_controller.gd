extends Node

@onready var room_container: Node2D = get_parent().get_node("RoomContainer")
@onready var health_ui = $HUD/VBoxContainer/HBoxContainer
@onready var purse_label = $HUD/VBoxContainer/CoinRow/Label
@onready var splitter_row = $HUD/VBoxContainer/SplitterRow
@onready var splitter_label = $HUD/VBoxContainer/SplitterRow/Label

var current_level: Node = null
var player: Node = null

func _ready() -> void:
	await get_tree().process_frame
	player = PlayerManager.player  # Autoload-Player holen
	
	# Startlevel laden
	var start_level_scene = load("res://Levels/Crib/crib-01.tscn") as PackedScene
	if not start_level_scene:
		push_error("Start-Level konnte nicht geladen werden!")
		return

	load_level(start_level_scene)

# --- Level laden (nur eine Instanz aktiv) ---
func load_level(level_scene: PackedScene) -> void:
	# Alte Instanz entfernen
	if current_level:
		current_level.queue_free()

	# Neue Instanz erstellen
	current_level = level_scene.instantiate()
	room_container.add_child(current_level)

	# Spawnpunkt suchen
	var spawn_point = current_level.get_node_or_null("PlayerSpawn")
	if spawn_point == null:
		push_error("PlayerSpawn nicht gefunden in Level '%s'" % current_level.name)
		return

	# Player in neues Level spawnen
	PlayerManager.spawn_player(spawn_point)

	# Player-Signale aktualisieren
	_setup_player_signals()

# --- Player-Signale verbinden ---
func _setup_player_signals() -> void:
	if player == null:
		return

	if player.has_signal("health_changed"):
		player.health_changed.disconnect_all(health_ui)
		player.health_changed.connect(health_ui.update_health)
		health_ui.update_health(player.health)

	if player.has_signal("splitters_changed"):
		player.splitters_changed.disconnect_all(self)
		player.splitters_changed.connect(_on_splitter_changed)
		_on_splitter_changed(player.splitter_item_count)

	if player.has_signal("purseContents_changed"):
		player.purseContents_changed.disconnect_all(self)
		player.purseContents_changed.connect(_on_purse_changed)

# --- HUD Updates ---
func _on_splitter_changed(new_count: int):
	if splitter_label:
		splitter_label.text = "%03d" % new_count
	if splitter_row:
		splitter_row.visible = new_count >= 1

func _on_purse_changed(new_total: int):
	if purse_label:
		purse_label.text = "%03d" % new_total
