extends CanvasLayer

var creatures : Array
const POSITIONS : Array[Vector2] = [Vector2(160,50),Vector2(420,100),Vector2(160,150),
					Vector2(420,200),Vector2(160,250),Vector2(420,300)]

func _ready() -> void:
	var blank : PackedScene = load("res://src/scenes/party_creature.tscn")
	for i in range(len(PlayerHandler.player.team)):
		creatures.append(blank.instantiate())
		add_child(creatures[i])
		creatures[i].set_sprite(PlayerHandler.player.team[i].species.party_sprite)
		creatures[i].position = POSITIONS[i]
		
		
