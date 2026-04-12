class_name PlayerResource extends Resource

var name : String
var money : int

var team : Array[CreatureResource]

func create_new(set_name : String) -> void:
	name = set_name
	add_to_team(load("res://test_battler.tres"))

func add_to_team(member : CreatureResource) -> bool:
	if team.size() == 6:
		return false
	team.append(member)
	return true
