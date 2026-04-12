extends Node2D

var opponent_team : Array[CreatureResource]

var player_current : int
var opponent_current : int

@onready var test_attacker : CreatureResource

func _ready() -> void:
	test_attacker = CreatureResource.new()
	test_attacker.update_from_species(load("res://data/species/testspecies.tres"))

func _on_move_selected(idx: int) -> void:
	print("Move "+str(idx))
	print(test_attacker)
	var dmg = 2
	if apply_damage(dmg, test_attacker):
		print("fainted")
	else:
		print(test_attacker.curr_hp)
	
func apply_damage(dmg: int, target : CreatureResource) -> bool:
	var faint = false
	var old_hp = target.curr_hp
	if dmg >= old_hp:
		faint = true
		dmg = old_hp
	target.curr_hp -= dmg
	
	return faint
	
