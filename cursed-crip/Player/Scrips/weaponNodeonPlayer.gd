extends Node2D

@export var bullet_scene: PackedScene 
@export var fire_rate: float = 2.0
@export var splitter_count: int 
@export var homing_item_count: int
@export var is_homing_unlocked: bool = false
var can_fire: bool = true

func fire():
	if not can_fire or bullet_scene == null:
		return
	start_cooldown()
	var shot_count = 1 + (splitter_count * 2)
	var spread_angle = deg_to_rad(15) # Total spread of 15 degrees between bullets

	# 2. Base direction toward mouse
	var mouse_pos = get_global_mouse_position()
	var base_direction = (mouse_pos - global_position).normalized()
	var base_angle = base_direction.angle()

	# 3. Spawn loop
	for i in range(shot_count):
		var bullet = bullet_scene.instantiate()
		
		# Position logic
		bullet.global_position = $Muzzle.global_position if has_node("Muzzle") else global_position
		
		# Calculate offset angle so the middle bullet stays on target
		# If shot_count is 3, offsets will be: -15°, 0°, +15°
		var angle_offset = (i - (shot_count - 1) / 2.0) * spread_angle
		var final_angle = base_angle + angle_offset
		
		# Apply direction and rotation
		bullet.direction = Vector2.from_angle(final_angle)
		bullet.rotation = final_angle
		
		
		if is_homing_unlocked:
			bullet.is_homing = true
			bullet.modulate = Color(1.419, 0.236, 0.009, 1.0)
		
		get_tree().root.add_child(bullet)
func start_cooldown():
	can_fire = false
	await get_tree().create_timer(fire_rate).timeout
	can_fire = true
func add_splitter():
	splitter_count += 1
func add_homing_item():
	homing_item_count += 1
func unlock_homing():
	is_homing_unlocked = true
