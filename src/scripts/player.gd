extends CharacterBody2D

@export var tile_size: int = 16
@export var move_speed: float = 160.0
@export var snap_duration: float = 0.1

var is_moving := false
var is_snapping := false
var input_buffer := Vector2.ZERO
var facing := Vector2.DOWN

@onready var walk_tiles: TileMapLayer = get_parent().get_node("FloorTiles")

var target_position: Vector2

func _ready() -> void:
	position = position.snapped(Vector2(tile_size, tile_size))
	target_position = position

func _physics_process(delta) -> void:
	if is_snapping:
		return

	if is_moving:
		move_to_target(delta)
	else:
		handle_input()

func handle_input() -> void:
	var direction := get_input_direction()

	if direction != Vector2.ZERO:
		input_buffer = direction

		# Turn in place if changing direction
		if facing != direction:
			facing = direction
			update_animation()
			return

		attempt_move(direction)
		input_buffer=Vector2(0.0,0.0)

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

func attempt_move(direction: Vector2) -> void:
	var new_target = position + direction * tile_size

	if can_move_to(new_target, direction):
		start_move(new_target)

func start_move(new_target: Vector2) -> void:
	target_position = new_target
	is_moving = true
	facing = (target_position - position).normalized()
	update_animation()

func move_to_target(delta) -> void:
	var direction = (target_position - position).normalized()
	velocity = direction * move_speed
	move_and_slide()

	if position.distance_to(target_position) < 2:
		finish_move()

func finish_move() -> void:
	position = target_position
	velocity = Vector2.ZERO

	snap_to_grid()
	var grid_pos = walk_tiles.local_to_map(position)
	var tile_data = walk_tiles.get_cell_tile_data(grid_pos)
	var ledge = tile_data.get_custom_data("is_ledge")
	if ledge != Vector2.ZERO:
		target_position = position + ledge * tile_size
		return
	is_moving = false
	if tile_data.get_custom_data("is_warp"):
		get_node("/root/GameManager").transition_from_warp(get_parent().name,grid_pos)
		

func snap_to_grid() -> void:
	var snap_pos = position.snapped(Vector2(tile_size, tile_size))

	if position == snap_pos:
		check_buffer()
		return

	is_snapping = true

	var tween = create_tween()
	tween.tween_property(self, "position", snap_pos, snap_duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	tween.finished.connect(_on_snap_finished)

func _on_snap_finished() -> void:
	is_snapping = false
	check_buffer()

func check_buffer() -> void:
	if input_buffer != Vector2.ZERO:
		attempt_move(input_buffer)

func can_move_to(target: Vector2, direction: Vector2) -> bool:
	var tile := walk_tiles.local_to_map(target)
	var data := walk_tiles.get_cell_tile_data(tile)
	if data:
		if not data.get_custom_data("is_walkable"):
			return false
		var ledge_dir : Vector2 = data.get_custom_data("is_ledge")
		if ledge_dir != Vector2.ZERO:
			return ledge_dir == direction
		return true
	return false

func update_animation() -> void:
	$AnimatedSprite2D.play("walk_" + direction_to_string(facing))

func direction_to_string(dir: Vector2) -> String:
	if dir == Vector2.RIGHT:
		return "right"
	elif dir == Vector2.LEFT:
		return "left"
	elif dir == Vector2.UP:
		return "up"
	elif dir == Vector2.DOWN:
		return "down"
	return "down"
