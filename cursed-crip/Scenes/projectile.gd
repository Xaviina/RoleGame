extends Area2D

var speed = 400.0
var direction = Vector2.ZERO

func _physics_process(delta):
	# Bewegt die Kugel in die gesetzte Richtung
	position += direction * speed * delta

func _on_body_entered(body):
	# Wenn die Kugel etwas trifft (Gegner oder Wand)
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free() # Kugel löschen
