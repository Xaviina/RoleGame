extends HBoxContainer

@export var heart_texture: Texture2D # Drag your heart image here in the Inspector

func update_health(current_health: int):
	# 1. Clear existing hearts
	for child in get_children():
		child.queue_free()
	
	# 2. Create new hearts based on current health
	for i in range(current_health):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		add_child(heart)
