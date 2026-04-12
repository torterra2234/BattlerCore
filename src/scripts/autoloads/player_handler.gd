extends Node

var player : PlayerResource = null

func _init():
	player = PlayerResource.new()
	player.create_new("Tester")
	for i in range(2):
		player.add_to_team(CreatureResource.new())
		player.team[i].update_from_species(load("res://data/species/testspecies.tres"))
		
	
