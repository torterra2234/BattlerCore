extends Node2D

var opponent_team : Array[CreatureResource]

var player_current : int
var opponent_current : int = 0

var player_creatures : Array
var opponent_creatures : Array

enum Action {MOVE, ITEM, SWITCH, RUN}
enum Menu {SELECT, FIGHT, PARTY}

var state : Action

var hp_bars : Dictionary

var player_choice : Resource

#menu items
var selection := 0
var menu := Menu.SELECT

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
	
func _process(_delta: float) -> void:
	var direction := get_input_direction()
	if direction != Vector2.ZERO:
		try_move_cursor(direction)
	if Input.is_action_just_pressed("ui_accept"):
		menu_select()
	if Input.is_action_just_pressed("ui_cancel"):
		menu_back()
		
func get_input_direction() -> Vector2:
	if Input.is_action_just_pressed("ui_right"):
		return Vector2.RIGHT
	elif Input.is_action_just_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_just_pressed("ui_down"):
		return Vector2.DOWN
	elif Input.is_action_just_pressed("ui_up"):
		return Vector2.UP

	return Vector2.ZERO
	
func try_move_cursor(direction : Vector2) -> void:
	match menu:
		Menu.SELECT:
			selection = clamp(selection + direction.x,selection-selection%2, selection+1-selection%2)
			selection = clamp(selection + 2*direction.y,0+selection%2,2+selection%2)
		Menu.FIGHT:
			var move_count := len(PlayerHandler.player.team[0].moves)
			selection = clamp(selection + direction.x,selection-selection%2,selection+1-selection%2)
			selection = clamp(selection + 2*direction.y,0+selection%2,2+selection%2)
			selection = clamp(selection,0,move_count-1)
	print(selection)
	update_cursor_location()
	
func update_cursor_location() -> void:
	match menu:
		Menu.SELECT:
			$Selection.position = Vector2(430+108*(selection%2),303+31*int(selection>1))
		Menu.FIGHT:
			$Selection.position = Vector2(12+104*(selection%2),303+31*int(selection>1))
		Menu.PARTY:
			pass
			
func menu_select() -> void:
	match menu:
		Menu.SELECT:
			match selection:
				0:
					print("FIGHT ME")
					menu = Menu.FIGHT
					selection = 0
					find_child("InitSelection").visible = false
					find_child("FightSelection").visible = true
					update_cursor_location()
				1:
					print("party")
				2:
					print("bag")
				3:
					print("run")
					state = Action.RUN
					calculate_round()
		Menu.FIGHT:
			state = Action.MOVE
			player_choice = load("res://data/moves/Smack.tres") #get_move() from creature
			calculate_round()
			
func menu_back() -> void:
	match menu:
		Menu.FIGHT:
			menu = Menu.SELECT
			selection = 0
			find_child("InitSelection").visible = true
			find_child("FightSelection").visible = false
			update_cursor_location()
	
func update_moves() -> void:
	var move_box := "Menus/FightSelection/LeftBox/GridContainer"
	#var info_box := "Menus/FightSelection/RightBox/VBoxContainer/Label"
	var movelist : Array[MoveResource] = PlayerHandler.player.team[0].moves
	var moves : int = len(movelist)
	for i in range(moves):
		var label : Label = get_node(move_box+"/Move"+str(i))
		label.text = movelist[i].name
	for i in range(4-moves):
		var label : Label = get_node(move_box+"/Move"+str(i+moves))
		label.text = ""
	
func _on_item_selected() -> void:
	state = Action.ITEM
	pass # Replace with function body.

func _on_party_selected() -> void:
	state = Action.SWITCH
	var party_screen = load("res://src/scenes/party_screen.tscn")
	party_screen = party_screen.instantiate()
	add_child(party_screen)
	
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
	@warning_ignore("integer_division")
	return move.base_power * user.attack / target.defence

@warning_ignore("unused_parameter")
func update_healthbar(target : CreatureResource) ->void:
	pass


	
	
	
	
