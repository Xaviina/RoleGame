extends Area2D

@export var item_name: String = "Projectile Splitter"
func _ready():
	# automatically connects signal
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.has_method("pick_up"):
		apply_item_logic(body) # this function is overridden by each pickableObject
		queue_free()

func apply_item_logic(player):
	player.pick_up("item", item_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
