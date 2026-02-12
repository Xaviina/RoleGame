extends Node2D

# 1. Get references to the nodes
# Adjust these paths to match your actual Scene Tree names!
@onready var player = $Player 
@onready var health_ui = $HUD/VBoxContainer/HBoxContainer 
@onready var purse_label = $HUD/VBoxContainer/CoinRow/Label 
@onready var splitter_row = $HUD/VBoxContainer/SplitterRow
@onready var splitter_label = $HUD/VBoxContainer/SplitterRow/Label
func _ready() -> void:
	# 2. Connect the signals from the player to the UI functions
	if player and health_ui:
		# Connect health signal: (signal_name).connect(target_function)
		player.health_changed.connect(health_ui.update_health)
		
		# 3. Initialize the UI with starting values
		health_ui.update_health(player.health)
	
	if player.has_signal("splitters_changed"):
		player.splitters_changed.connect(_on_splitter_changed)
		_on_splitter_changed(player.splitter_item_count)
	
	
	if player.has_signal("purseContents_changed") and has_node("HUD/VBoxContainer/CoinRow/Label"):
		player.purseContents_changed.connect(_on_purse_changed)


func _on_purse_changed(new_total: int):
	$HUD/VBoxContainer/CoinRow/Label.text = "%03d" % new_total

func _on_splitter_changed(new_count: int):
	# Update the text label
	splitter_label.text = "%03d" % new_count
	
	# Toggle visibility: visible if count is 1 or more, hidden if 0
	splitter_row.visible = new_count >= 1
