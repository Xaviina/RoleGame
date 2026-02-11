extends Area2D

var speed = 200.0
var direction = Vector2.ZERO
@export var is_homing: bool = false
@export var steer_force: float = 25.0 # How "sharp" the turn is
var target: Node2D = null

func _ready():
	# Randomly flip or rotate the rock so they aren't all the same
	$Sprite2D.flip_h = randf() > 0.5
	$Sprite2D.flip_v = randf() > 0.5
	$Sprite2D.rotation = randf_range(0, TAU)

func _physics_process(delta):
	#homing movement logic
	if is_homing:
		find_target()
		if target and is_instance_valid(target):
			# Calculate the direction to the target
			var desired_velocity = (target.global_position - global_position).normalized() * speed
			# Gradually turn the current direction toward the target
			direction = direction.lerp(desired_velocity.normalized(), steer_force * delta)
			rotation = direction.angle()
			
	# Standard movement logic
	position += direction * speed * delta

func find_target():
	# Only look for a target if we don't have one
	if target == null:
		var enemies = get_tree().get_nodes_in_group("enemies")
		if enemies.size() > 0:
			# Simple logic: pick the first enemy in the list
			# You could expand this to find the *closest* enemy
			target = enemies[0]


func _on_body_entered(body):
	# when rock hits something
	if body.has_method("take_damage"):
		body.take_damage(10)
	queue_free() #deletes the rock
