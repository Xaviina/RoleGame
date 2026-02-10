extends BaseItem

@export var damage: int = 10

# Override pickableObject method
func apply_item_logic(player):
	player.pick_up("weapon", item_name)
	print("Info: Does ", damage, " Damage.")
