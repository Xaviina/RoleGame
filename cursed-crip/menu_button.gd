extends Button


func _ready() -> void:
	pass 

func _on_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited() -> void:
	scale = Vector2(1, 1)

func _on_button_down() -> void:
	scale = Vector2(0.97, 0.97)

func _on_button_up() -> void:
	scale = Vector2(1.05, 1.05)
