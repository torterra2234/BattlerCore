class_name CreatureResource extends Resource

@export var name : String
@export var species : SpeciesResource

@export var curr_hp : int

@export var level : int
@export var max_hp : int
@export var attack : int
@export var defence : int

@export var moves : Array[MoveResource]

func update_from_species(new_species: SpeciesResource) -> void:
	species = new_species
	max_hp = species.base_hp
	attack = species.base_attack
	defence = species.base_defence
	curr_hp = max_hp
	moves.append(load("res://data/moves/Smack.tres")) #needs be custom function
	
func get_nickname() -> String:
	if name != "":
		return name
	else:
		return species.name

##handling for front/back/shiny frames
func get_battle_sprites() -> SpriteFrames:
	return species.sprite
