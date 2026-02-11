extends Area2D

@export var item_name: String = "Coin"
func _ready():
	# automatically connects signal
	body_entered.connect(_on_body_entered)

#what happens when Player hits the Coin
func _on_body_entered(body: Node2D):
	if body.has_method("pick_up"):
		apply_item_logic(body)
		queue_free()

func apply_item_logic(player):
	player.pick_up("item", item_name)


func _process(delta: float) -> void:
	pass
