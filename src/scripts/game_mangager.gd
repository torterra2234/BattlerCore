extends Node2D

var next_scene : String

func transition_from_warp(map : String, tile : Vector2) -> void:
	#lazy! handle better in future
	if map == "Overworld":
		transition_to_map("assets/maps/house1.tscn",Vector2(1,2))
	else:
		transition_to_map("assets/maps/overworld.tscn",Vector2(2,2))

func transition_to_map(new_scene : String,location : Vector2) -> void:
	next_scene = new_scene
	$Current.get_child(0).queue_free()
	$Current.add_child(load(next_scene).instantiate())
	var player = get_child(0).get_children().back().find_child("Player")
	var tiles : TileMapLayer = get_child(0).get_children().back().find_child("FloorTiles")
	player.position = tiles.map_to_local(location)-Vector2(8,8)
	
func trasition_to_battle() -> void:
	pass
	
	
