extends Node2D

var player

@onready var health_ui = $HUD/VBoxContainer/HBoxContainer
@onready var purse_label = $HUD/VBoxContainer/CoinRow/Label
@onready var splitter_row = $HUD/VBoxContainer/SplitterRow
@onready var splitter_label = $HUD/VBoxContainer/SplitterRow/Label


func _ready() -> void:
	await _wait_for_player()
	player = PlayerManager.player

	# --- Health ---
	if player and health_ui:
		if player.has_signal("health_changed"):
			player.health_changed.connect(health_ui.update_health)
			health_ui.update_health(player.health)

	# --- Splitter ---
	if player and player.has_signal("splitters_changed"):
		player.splitters_changed.connect(_on_splitter_changed)
		_on_splitter_changed(player.splitter_item_count)

	# --- Coins ---
	if player and player.has_signal("purseContents_changed"):
		player.purseContents_changed.connect(_on_purse_changed)


func _wait_for_player():
	while PlayerManager.player == null:
		await get_tree().process_frame


func _on_purse_changed(new_total: int):
	if purse_label:
		purse_label.text = "%03d" % new_total


func _on_splitter_changed(new_count: int):
	if splitter_label:
		splitter_label.text = "%03d" % new_count
	if splitter_row:
		splitter_row.visible = new_count >= 1
