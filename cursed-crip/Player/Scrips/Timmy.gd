extends CharacterBody2D

var inventory = {
	"weapon": null, # Name oder Dictionary der Waffe
	"item": null    # Gleiches für das Item
}

const SPEED = 150.0  # Bewegungsgeschwindigkeit

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	
	# SCHIESSEN LOGIK
	# Prüft, ob die Taste "shoot" gedrückt wurde UND ob ein Node namens "Weapon" existiert
	if Input.is_action_just_pressed("shoot"):
		# 1. Prüfen: Haben wir laut Inventar überhaupt eine Waffe?
		if inventory["weapon"] != null:
			# 2. Prüfen: Existiert der Weapon-Node, um den Schuss auszuführen?
			if has_node("Weapon"):
				get_node("Weapon").fire()
		else:
			print("Du hast noch keine Waffe aufgehoben!")

func get_input():
	# Richtung wird aus der Input Map gelesen!
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if direction != Vector2.ZERO:
		velocity = direction * SPEED
	else:
		# Sanfteres Anhalten
		velocity = velocity.move_toward(Vector2.ZERO, SPEED)
	
	# Animationen und Flipping
	update_animations(direction)

func update_animations(direction: Vector2):
	if direction.x > 0:
		$AnimatedSprite2D.play("run_left_to_right")
		$AnimatedSprite2D.flip_h = false
	elif direction.x < 0:
		$AnimatedSprite2D.play("run_left_to_right")
		$AnimatedSprite2D.flip_h = true
	elif direction.y != 0:
		# Spielt Lauf-Animation auch bei vertikaler Bewegung
		$AnimatedSprite2D.play("run_left_to_right")	else:
		$AnimatedSprite2D.play("stand")
		
# Funktion für das Aufheben von Items und Waffen
func pick_up(type: String, item_name: String):
	if type == "weapon":
		inventory["weapon"] = item_name
		# Hier könntest du später ein UI-Icon aktualisieren
	elif type == "item":
		inventory["item"] = item_name
