extends Area2D

var speed = 400.0
var direction = Vector2.RIGHT
var is_homing: bool = false
var steer_force = 15.0 # How fast the bullet turns (radians/sec)

func _physics_process(delta):
	if is_homing:
		# 1. Find the enemy that is CURRENTLY closest to this specific bullet
		var target = find_nearest_enemy()
		
		if is_instance_valid(target):
			# 2. Calculate the direction to that specific enemy
			var desired = (target.global_position - global_position).normalized()
			
			# 3. Smoothly steer the current direction toward the desired direction
			direction = direction.lerp(desired, steer_force * delta).normalized()
			
			# 4. Make the bullet sprite face where it's going
			rotation = direction.angle()

	# Move the bullet based on its (potentially updated) direction
	position += direction * speed * delta

func find_nearest_enemy() -> Node2D:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var nearest_enemy = null
	var nearest_distance = INF # Start with "Infinity"
	
	for enemy in enemies:
		# We check distance from THIS bullet to each enemy
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
			
	return nearest_enemy

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free()
