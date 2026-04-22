extends Node

var player : PlayerResource = null

func _init() -> void:
	player = PlayerResource.new()
	player.create_new("Tester")
	for i in range(4):
		player.add_to_team(CreatureResource.new())
	player.team[0].update_from_species(load("res://data/species/testspecies.tres"))
	player.team[1].update_from_species(load("res://data/species/circle.tres"))
	player.team[2].update_from_species(load("res://data/species/square.tres"))
	player.team[3].update_from_species(load("res://data/species/triangle.tres"))
		
