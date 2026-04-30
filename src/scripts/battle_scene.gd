extends Node2D

var opponent_team : Array[CreatureResource]

var player_current : int
var opponent_current : int = 0

var player_creatures : Array
var opponent_creatures : Array

enum Menu {SELECT, FIGHT, PARTY, BAG}
const MOVE_FIRST : int = 10000

var hp_bars : Dictionary

var queue : Array[Dictionary] #does not allow nesting static typing :(

var ai := BlankAI.new()

#menu items
var selection := 0
var menu := Menu.SELECT
var party_screen : CanvasLayer


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
	var party_screen_scene := load("res://src/scenes/party_screen.tscn")
	party_screen = party_screen_scene.instantiate()
	add_child(party_screen)
	party_screen.visible = false
	
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
		Menu.PARTY:
			var team_count := len(PlayerHandler.player.team)
			selection = clamp(selection + direction.x,selection-selection%2,selection+1-selection%2)
			selection = clamp(selection + 2*direction.y,0+selection%2,4+selection%2)
			selection = clamp(selection,0,team_count-1)
		Menu.BAG:
			pass
	print(selection)
	update_cursor_location()
	
func update_cursor_location() -> void:
	match menu:
		Menu.SELECT:
			$Selection.position = Vector2(430+108*(selection%2),303+31*int(selection>1))
		Menu.FIGHT:
			$Selection.position = Vector2(12+104*(selection%2),303+31*int(selection>1))
		Menu.PARTY:
			party_screen.hover(selection)
			
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
					print("bag")
					#this is currently a later feature
				2:
					print("party")
					menu = Menu.PARTY
					selection = 0
					party_screen.hover(0)
					party_screen.visible = true
				3:
					print("run")
					queue_add(MOVE_FIRST,run_away,[])
					calculate_round()
		Menu.FIGHT:
			queue_add(player_creatures[0].get_stat("speed"),attack,[player_creatures[0],opponent_creatures[0],load("res://data/moves/Smack.tres")])
			calculate_round()
		Menu.PARTY:
			pass
			
func menu_back() -> void:
	match menu:
		Menu.FIGHT:
			menu = Menu.SELECT
			selection = 0
			find_child("InitSelection").visible = true
			find_child("FightSelection").visible = false
			update_cursor_location()
		Menu.PARTY:
			menu = Menu.SELECT
			selection = 2
			party_screen.visible = false
	
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
	
func calculate_round() -> void:
	#needs:
	#item check, run check, speed check -> LATER PROBLEMS
	queue_add(opponent_creatures[0].get_stat("speed"),attack,[opponent_creatures[0],player_creatures[0],ai.next_action()])
	queue.sort_custom(queue_sort)
	var action : Dictionary
	while len(queue) > 0:
		action = queue_next()
		action.call.call(action.data)
	#var opp_move := load("res://data/moves/Smack.tres") #get_opponent_move() ai function
	#player_creatures[0].apply_dmg(calculate_dmg(player_choice,PlayerHandler.player.team[player_current],opponent_team[opponent_current],false))
	#opponent_creatures[0].apply_dmg(calculate_dmg(opp_move,opponent_team[opponent_current],PlayerHandler.player.team[player_current],false))

##move handler for abilities, accuracy, crits etc
func calc_move() -> int:
	return 2

##basic damage calculation
func calculate_dmg(move : MoveResource, user : CreatureResource, target : CreatureResource, _crit : bool) -> int:
	@warning_ignore("integer_division")
	return move.base_power * user.attack / target.defence

func queue_add(speed : int, action : Callable, args : Array) ->void:
	queue.append({"speed" : speed, "call" : action, "data" : args})
	
func queue_sort(a : Dictionary, b : Dictionary) -> bool:
	# will need randomised tie solving, but for now, basics
	return a.speed > b.speed
	
func queue_next() -> Dictionary:
	return queue.pop_back()
	
func attack(args : Array) -> void:
	var user : Node2D = args[0]
	var target : Node2D = args[1]
	var move : MoveResource = args[2]
	target.apply_dmg(calculate_dmg(move,user.creature,target.creature,false))
	pass
	
func run_away(_args : Array) -> void:
	get_tree().quit()
	
	
	
	
