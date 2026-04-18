class_name PlayerResource extends Resource

var name : String
var money : int

var team : Array[CreatureResource]

func create_new(player_name : String) -> void:
	name = player_name

func add_to_team(member : CreatureResource) -> bool:
	if team.size() == 6:
		return false
	team.append(member)
	return true
