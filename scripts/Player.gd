extends Actor

onready var grounded_tolerance_timer = get_node("grounded_tolerance_timer")
onready var jump_trigger_tolerance_timer = get_node("jump_trigger_tolerance_timer")

var can_jump = true
var grounded_last_frame;

func _physics_process(delta):
	
	var direction = get_direction()
	_velocity = calculcate_move_velocity(_velocity, direction, speed)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

	# Grounded jump tolearance 
	if Input.is_action_just_pressed("jump"):
		can_jump = false;
		jump_trigger_tolerance_timer.start()

	if (is_on_floor() == false) and (grounded_last_frame == true) :
		grounded_tolerance_timer.start()
		
	if (is_on_floor()):
		grounded_last_frame = true
		can_jump = true;
	else: 
		grounded_last_frame = false
	
		# Prevents unintetional double jump when hittin a low ceiling 	
	if is_on_ceiling():
		jump_trigger_tolerance_timer.stop()
	# /Grounded jump tolerance	
	
func get_direction():
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		-1.0 if (jumped() and is_grounded() and can_jump) else 1.0
	)
	
func calculcate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity
	
func is_grounded():
	return is_on_floor() or (grounded_tolerance_timer.time_left > 0 and _velocity.y > 0)
	
func jumped():
	return jump_trigger_tolerance_timer.time_left > 0 or Input.is_action_just_pressed("jump")
