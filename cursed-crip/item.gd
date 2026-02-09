extends BaseItem

@export var heal_amount: int = 20

func apply_item_logic(player):
	player.pick_up("item", item_name)
	if player.has_method("heal"):
		player.heal(heal_amount)
