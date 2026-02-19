extends Node2D

var player

@onready var health_ui = $HUD/VBoxContainer/HBoxContainer 
@onready var purse_label = $HUD/VBoxContainer/CoinRow/Label 
@onready var splitter_row = $HUD/VBoxContainer/SplitterRow
@onready var splitter_label = $HUD/VBoxContainer/SplitterRow/Label

func _ready() -> void:
	await _wait_for_player()
	player = PlayerManager.player

	if player and health_ui:
		player.health_changed.connect(health_ui.update_health)
		health_ui.update_health(player.health)

	if player.has_signal("splitters_changed"):
		player.splitters_changed.connect(_on_splitter_changed)
		_on_splitter_changed(player.splitter_item_count)

	if player.has_signal("purseContents_changed"):
		player.purseContents_changed.connect(_on_purse_changed)

func _wait_for_player():
	while PlayerManager.player == null:
		await get_tree().process_frame

func _on_purse_changed(new_total: int):
	purse_label.text = "%03d" % new_total

func _on_splitter_changed(new_count: int):
	splitter_label.text = "%03d" % new_count
	splitter_row.visible = new_count >= 1
