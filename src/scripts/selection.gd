extends AnimatedSprite2D

signal move_selected(idx : int)
signal item_selected
signal party_selected
signal run_selected


var location := Vector2.ZERO
var menu := ""

enum MODE {SELECT, FIGHT}

var input_buffer : Vector2

func _process(_delta: float) -> void:
	var direction := get_input_direction()

	if direction != Vector2.ZERO:
		input_buffer = direction

		try_move(direction)
		input_buffer=Vector2.ZERO
	if Input.is_action_just_pressed("ui_accept"):
		select()
	if Input.is_action_just_pressed("ui_cancel"):
		back()

func get_input_direction() -> Vector2:
	if Input.is_action_pressed("ui_right"):
		return Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		return Vector2.UP

	return Vector2.ZERO
	
func try_move(direction : Vector2) -> void:
	location += direction
	location = location.clamp(Vector2.ZERO,Vector2(1,1))
	update_location()
	
func update_location() -> void:
	if menu == "fight":
		match location:
			Vector2.ZERO:
				position = Vector2(12,303)
			Vector2.DOWN:
				position = Vector2(12,334)
			Vector2.RIGHT:
				position = Vector2(216,303)
			Vector2(1,1):
				position = Vector2(216,334)
			_:
				pass
	else:
		match location:
			Vector2.ZERO:
				position = Vector2(430,303)
			Vector2.DOWN:
				position = Vector2(430,334)
			Vector2.RIGHT:
				position = Vector2(538,303)
			Vector2(1,1):
				position = Vector2(538,334)
			_:
				pass
			
func select() -> void:
	if menu == "fight":
		match location:
			Vector2.ZERO:
				move_selected.emit(1)
			Vector2.DOWN:
				move_selected.emit(3)
			Vector2.RIGHT:
				move_selected.emit(2)
			Vector2(1,1):
				move_selected.emit(4)
	else:
		match location:
			Vector2.ZERO:
				print("FIGHT ME")
				menu = "fight"
				location = Vector2.ZERO
				get_parent().find_child("InitSelection").visible = false
				get_parent().find_child("FightSelection").visible = true
				update_location()
			Vector2.DOWN:
				print("swap")
			Vector2.RIGHT:
				print("bag")
			Vector2(1,1):
				run_selected.emit()
			
func back() -> void:
	if menu == "fight":
		menu = ""
		location = Vector2.ZERO
		get_parent().find_child("InitSelection").visible = true
		get_parent().find_child("FightSelection").visible = false
		update_location()
			
