extends CharacterBody2D

var inventory = {
	"weapon": null, # Name oder Dictionary der Waffe
	"item": null    # Gleiches für das Item
}
signal health_changed(new_health: int)
signal purseContents_changed(new_total: int)
signal splitters_changed(new_total: int)

var splitter_item_count: int = 0
var purse: int = 0

var health: int = 3:
	set(value):
		health = value
		health_changed.emit(health) # Shout out that health changed!

const SPEED = 120.0  # Bewegungsgeschwindigkeit

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
		$AnimatedSprite2D.play("run_left_to_right")
	else:
		$AnimatedSprite2D.play("stand")
		
#function for pick up
func pick_up(type: String, item_name: String):
	if item_name == "Homing Rock":
		$Weapon.unlock_homing()
	if item_name == "Heart":
		health += 1
	if item_name == "Coin":
		purse += 1
		purseContents_changed.emit(purse)
	if type == "weapon":
		inventory["weapon"] = item_name
	# Check if we have the weapon equipped and if the item is a splitter
	if has_node("Weapon"):
		var weapon_node = get_node("Weapon")
		
		if item_name == "Projectile Splitter":
			splitter_item_count += 1
			splitters_changed.emit(splitter_item_count)
			if weapon_node.has_method("add_splitter"):
				weapon_node.add_splitter()
