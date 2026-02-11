extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)

func _on_button_down() -> void:
	scale = Vector2(0.97, 0.97)

func _on_button_up() -> void:
	scale = Vector2(1.05, 1.05)
