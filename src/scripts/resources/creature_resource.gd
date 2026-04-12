class_name CreatureResource extends Resource

@export var name : String
@export var species : SpeciesResource

@export var curr_hp : int

@export var max_hp : int
@export var attack : int
@export var defense : int

@export var moves : Array[MoveResource]

func update_from_species(new_species: SpeciesResource):
	species = new_species
	max_hp = species.base_hp
	attack = species.base_attack
	defense = species.base_defence
	curr_hp = max_hp
	moves.append(load("res://data/moves/Smack.tres"))
	
