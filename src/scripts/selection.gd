extends AnimatedSprite2D

var location := Vector2.ZERO
var menu := ""

var input_buffer

func _process(_delta: float) -> void:
	var direction := get_input_direction()

	if direction != Vector2.ZERO:
		input_buffer = direction

		try_move(direction)
		input_buffer=Vector2.ZERO
	if Input.is_action_just_pressed("ui_accept"):
		select()

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
	
func try_move(direction) -> void:
	location += direction
	location = location.clamp(Vector2.ZERO,Vector2(1,1))
	update_location()
	
func update_location() -> void:
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
	match location:
		Vector2.ZERO:
			print("FIGHT ME")
		Vector2.DOWN:
			print("swap")
		Vector2.RIGHT:
			print("bag")
		Vector2(1,1):
			get_tree().quit()
			
