extends Node2D


@export var bullet_scene: PackedScene 
@export var fire_rate: float = 0.3 # Zeit zwischen Schüssen

var can_fire: bool = true

func fire():
	if not can_fire:
		return
	
	if bullet_scene == null:
		print("Fehler: Keine Bullet-Szene in der Waffe zugewiesen!")
		return

	# 1. Kugel erstellen
	var bullet = bullet_scene.instantiate()
	
	# 2. Position setzen (am Marker 'Muzzle' oder am Waffen-Zentrum)
	if has_node("Muzzle"):
		bullet.global_position = $Muzzle.global_position
	else:
		bullet.global_position = global_position
	
	# 3. Richtung zur Maus berechnen
	var mouse_pos = get_global_mouse_position()
	var shoot_direction = (mouse_pos - global_position).normalized()
	
	# 4. Richtung und Rotation an Kugel übergeben
	bullet.direction = shoot_direction
	bullet.rotation = shoot_direction.angle()
	
	# 5. Kugel der Welt hinzufügen (damit sie unabhängig fliegt)
	get_tree().root.add_child(bullet)
	
	# 6. Cooldown starten
	start_cooldown()

func start_cooldown():
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
