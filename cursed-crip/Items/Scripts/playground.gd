extends Node2D

# variables for the paths
@onready var player = $Player
@onready var heart_container = $HUD/VBoxContainer/HeartContainer
@onready var coin_label = $HUD/VBoxContainer/CoinRow/Label
@onready var splitter_label = $HUD/VBoxContainer/SplitterRow/Label
@onready var coin_icon = $HUD/VBoxContainer/CoinRow/TextureRect

func _ready():
	#Hearts
	if has_node("Player") and has_node("HUD/VBoxContainer/HeartContainer"):
		player.health_changed.connect(heart_container.update_health)
		heart_container.update_health(player.health)

	#Coins
	if player.has_signal("purseContents_changed"):
		player.purseContents_changed.connect(_on_purse_changed)
		# Startwert setzen (000)
		coin_label.text = "%03d" % player.purse

	#Splitter
	if player.has_signal("splitters_changed"):
		player.splitters_changed.connect(_on_splitters_changed)
		# Startwert setzen (00)
		splitter_label.text = "%03d" % player.splitter_item_count

func _on_purse_changed(new_val):
	coin_label.text = "%03d" % new_val
	
func _on_splitters_changed(new_val):
	if splitter_label:
		splitter_label.text = "%03d" % new_val
		
		# Number Bounces a bit for more interesting feeling
		splitter_label.pivot_offset = splitter_label.size / 2
		var tw = create_tween()
		tw.tween_property(splitter_label, "scale", Vector2(1.2, 1.2), 0.1)
		tw.tween_property(splitter_label, "scale", Vector2(1.0, 1.0), 0.1)
