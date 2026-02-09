extends Area2D
# Das ist dein Script für das Item, das im Level herumliegt

@export var item_name: String = "Gewehr"
@export var damage: int = 15
@export var weapon_bullet_scene: PackedScene # Hier die Bullet.tscn im Inspektor zuweisen!

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player" or body.has_method("pick_up"):
		apply_item_logic(body)
		queue_free() # Entfernt das Item vom Boden

func apply_item_logic(player):
	# 1. Schreibt die Waffe ins Inventar des Spielers
	player.pick_up("weapon", item_name)
	
	# 2. Aktiviert die Schuss-Fähigkeit im 'Weapon'-Node des Spielers
	if player.has_node("Weapon"):
		var weapon_node = player.get_node("Weapon")
		weapon_node.bullet_scene = weapon_bullet_scene
		print(item_name, " wurde dem Inventar hinzugefügt und ausgerüstet!")
