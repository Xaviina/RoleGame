extends Area2D
#

@export var item_name: String = "Slingshot"
@export var damage: int = 15
@export var weapon_bullet_scene: PackedScene

func _ready():
	body_entered.connect(_on_body_entered)

#functionality when Player hits item
func _on_body_entered(body):
	if body.name == "Player" or body.has_method("pick_up"):
		apply_item_logic(body)
		queue_free() 

func apply_item_logic(player):
	player.pick_up("weapon", item_name)
	
	# activates the ability to shoot for the player
	if player.has_node("Weapon"):
		var weapon_node = player.get_node("Weapon")
		weapon_node.bullet_scene = weapon_bullet_scene
