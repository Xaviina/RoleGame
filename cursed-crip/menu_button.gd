extends Button

@onready var overlay = $Overlay

func _ready():
	overlay.self_modulate = Color(0, 0, 0, 0.18)

func _on_mouse_entered():
	scale = Vector2(1.03, 1.03)
	overlay.self_modulate.a = 0.28

func _on_mouse_exited():
	scale = Vector2(1, 1)
	overlay.self_modulate.a = 0.18

func _on_button_down():
	scale = Vector2(0.97, 0.97)
	overlay.self_modulate.a = 0.35

func _on_button_up():
	scale = Vector2(1.03, 1.03)
	overlay.self_modulate.a = 0.28
