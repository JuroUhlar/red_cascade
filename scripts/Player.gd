extends Actor

export var speed: = Vector2(200.0, 500.0)

onready var grounded_tolerance_timer = get_node("grounded_tolerance_timer")
onready var jump_trigger_tolerance_timer = get_node("jump_trigger_tolerance_timer")

export var dash_speed_multiplier = 3.0
export var dash_jump_multiplier = 1.0
export var dash_cooldown_modulation_color = Color(1,1,1,1)
export (PackedScene) var player_bullet
export var hp = 30

var can_jump = true
var grounded_last_frame
var dashing = false
var dashing_direction = Vector2.ZERO
var dashing_velocity = Vector2.ZERO
var jumping = false
var running = false
var shooting = false
var can_shoot = true
var dying = false


func _ready():
	add_to_group("player")
	add_to_group("damageable")

func _physics_process(delta):	
	if(dying):
		pass
	elif(dashing):
		_velocity = move_and_slide(dashing_velocity, FLOOR_NORMAL)
		$trail.emitting = true
	else:
		var direction = get_direction()
		_velocity = calculcate_move_velocity(_velocity, direction, speed)
		_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
		

		if Input.is_action_pressed("move_left"):
			$Sprite.flip_h = true
			running = true
			if sign($gun_muzzle.position.x) == 1:
				$gun_muzzle.position.x *= -1
		elif Input.is_action_pressed("move_right"):
			$Sprite.flip_h = false
			running = true
			if sign($gun_muzzle.position.x) == -1:
				$gun_muzzle.position.x *= -1
		else:
			running = false	
	
		if Input.is_action_just_pressed("dash") and $dash_cooldown.time_left <= 0:
			dashing = true
			dashing_direction = get_dash_direction()
			dashing_velocity = calculate_dash_velocity(dashing_direction, speed, dash_speed_multiplier, dash_jump_multiplier)
			$dash_timer.start()
			
		jumping = can_jump and jumped() and is_grounded()
		
		if Input.is_action_pressed("shoot") and !shooting and can_shoot:
			shooting = true
			can_shoot = false
			$gun_timer.start()
			var projectile = player_bullet.instance()
			if sign($gun_muzzle.position.x) == 1:
				projectile.set_projectile_direction(1)
			else:
				projectile.set_projectile_direction(-1)
			get_parent().add_child(projectile)
			projectile.position = $gun_muzzle.global_position
			
		
		# Sprite management based on state
		if shooting:
			$Sprite.play("shoot")
		elif dashing && Input.is_action_pressed("move_up"):
			$Sprite.play("jump")
		elif dashing:
			$Sprite.play("dash")	
		elif _velocity.y < 0:
			$Sprite.play("jump")	
		elif !is_on_floor():
			$Sprite.play("fall")
		elif running: 
			$Sprite.play("run")	
		else: $Sprite.play("idle")
		
		if $dash_cooldown.time_left > 0:
			$Sprite.modulate = dash_cooldown_modulation_color 
		else: 
			$Sprite.modulate = Color(1,1,1,1)
			
		# Grounded jump tolerance 
		if Input.is_action_just_pressed("jump") :
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
		-1.0 if jumping else 1.0
	)
	
func calculcate_move_velocity(linear_velocity: Vector2,	direction: Vector2, speed: Vector2) -> Vector2:
	var new_velocity = linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity
	
func get_dash_direction() -> Vector2:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		direction.y = -1.0
		direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	else:
		direction.x = 1.0 if ($Sprite.flip_h == false) else -1.0
	return direction
	
func calculate_dash_velocity(direction: Vector2, speed: Vector2, dash_speed_multiplier: float, dash_jump_multiplier: float) -> Vector2:
	var velocity = Vector2.ZERO
	velocity.x = direction.x * speed.x * dash_speed_multiplier
	velocity.y = direction.y * speed.y * dash_jump_multiplier
	return velocity
	
func is_grounded():
	return is_on_floor() or (grounded_tolerance_timer.time_left > 0 and _velocity.y > 0)
	
func jumped():
	return jump_trigger_tolerance_timer.time_left > 0 or Input.is_action_just_pressed("jump")

func _on_dash_timer_timeout():
	dashing = false
	$trail.emitting = false
	$dash_cooldown.start()

func _on_ghost_timer_timeout():
	if dashing:
		var this_ghost = preload("res://Scenes/Ghost.tscn").instance()
		get_parent().add_child(this_ghost)
		this_ghost.position = position
		this_ghost.texture = $Sprite.frames.get_frame($Sprite.animation, $Sprite.frame)
		this_ghost.flip_h = $Sprite.flip_h


func _on_Sprite_animation_finished():
	shooting = false

func _on_gun_timer_timeout():
	can_shoot = true


func _on_enemy_detector_body_entered(body):
	if body.is_in_group("enemies"):
		if (!dashing):
			die()
		
func die():
	dying = true
	$Sprite.play("die")
	yield($Sprite, "animation_finished")
	$death_timer.start()
	
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		die()

func _on_death_timer_timeout():
	get_tree().reload_current_scene()
