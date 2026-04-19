extends Node2D

var opponent_team : Array[CreatureResource]

var player_current : int
var opponent_current : int = 0

var player_creatures : Array
var opponent_creatures : Array

enum Action {MOVE, ITEM, SWITCH, RUN}
var state : Action

var hp_bars : Dictionary

var player_choice : Resource

func _ready() -> void:
	opponent_team.append(CreatureResource.new())
	opponent_team[0].update_from_species(load("res://data/species/testspecies.tres"))
	var battle_template : PackedScene = load("res://src/scenes/battle_creature.tscn")
	player_creatures.append(battle_template.instantiate())
	add_child(player_creatures[0])
	player_creatures[0].setup("single_player",PlayerHandler.player.team[0])
	opponent_creatures.append(battle_template.instantiate())
	add_child(opponent_creatures[0])
	opponent_creatures[0].setup("single_opponent",opponent_team[0])
	update_moves()
	
func update_moves() -> void:
	var move_box := "Menus/FightSelection/LeftBox/GridContainer"
	var info_box := "Menus/FightSelection/RightBox/VBoxContainer/Label"
	var movelist : Array[MoveResource] = PlayerHandler.player.team[0].moves
	var moves : int = len(movelist)
	for i in range(moves):
		var label : Label = get_node(move_box+"/Move"+str(i))
		label.text = movelist[i].name
	for i in range(4-moves):
		var label : Label = get_node(move_box+"/Move"+str(i+moves))
		label.text = ""
	

func _on_move_selected(idx: int) -> void:
	state = Action.MOVE
	player_choice = load("res://data/moves/Smack.tres") #get_move() from creature
	calculate_round()

func _on_item_selected() -> void:
	state = Action.ITEM
	pass # Replace with function body.

func _on_party_selected() -> void:
	state = Action.SWITCH
	pass # Replace with function body.

func _on_run_selected() -> void:
	state = Action.RUN
	calculate_round()
	
func calculate_round() -> void:
	#needs:
	#item check, run check, speed check -> LATER PROBLEMS
	if state == Action.RUN:
		get_tree().quit()
		return
	var opp_move := load("res://data/moves/Smack.tres") #get_opponent_move() ai function
	player_creatures[0].apply_dmg(calculate_dmg(player_choice,PlayerHandler.player.team[player_current],opponent_team[opponent_current]))
	opponent_creatures[0].apply_dmg(calculate_dmg(opp_move,opponent_team[opponent_current],PlayerHandler.player.team[player_current]))

func calculate_dmg(move : MoveResource, user : CreatureResource, target : CreatureResource) -> int:
	return move.base_power * user.attack / target.defence

func update_healthbar(target : CreatureResource) ->void:
	pass


	
	
	
	
