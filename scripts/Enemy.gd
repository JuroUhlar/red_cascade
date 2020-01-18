extends Actor

export var speed = Vector2(100,200)
export var hp = 30
export var active = false

export (Array, NodePath) var death_trigger_target_Paths

var dying = false

func _ready():
	_velocity.x = speed.x
	set_physics_process(false)
	add_to_group("enemies")
	add_to_group("damageable")
	if(!active):
		$Sprite.play("dormant")
		$CollisionShape2D.scale = Vector2.ZERO
	else:
		$Sprite.play("spawn")
		$CollisionShape2D.scale = Vector2.ONE
		$nav_timer.start()

func _physics_process(delta):
	if(dying or !active):
		pass
	else:
		_velocity.y += gravity * delta
		if is_on_wall():
			_velocity.x *= -1.0		
			
		_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
		
		if sign(_velocity.x) == 1:
			$Sprite.flip_h = true
		else: 
			$Sprite.flip_h = false
			
		$Sprite.play("walk")
		
func take_damage(damage):
	hp -= damage
	if hp <= 0:
		die()
		
func die():
	dying = true
	$CollisionShape2D.disabled = true
	$CollisionShape2D.scale = Vector2.ZERO
	remove_from_group("enemies")
	$Sprite.play("die")
	yield($Sprite, "animation_finished")
	activate_targets()
	queue_free()

func activate():
	$Sprite.play("spawn")
	yield($Sprite, "animation_finished")
	if ($AnimationPlayer): $AnimationPlayer.play("spawn")
	$CollisionShape2D.scale = Vector2.ONE
	follow_player()
	$nav_timer.start()
	active = true

func _on_player_detector_body_entered(body):
	if(!active and body.is_in_group("player")):
		activate()
		
func follow_player():
	if ($RayCast_left.is_colliding() and sign(_velocity.x) == 1) :
		if ($RayCast_left.get_collider().name == "Player"):
			_velocity.x *= -1.0
		
	if ($RayCast_right.is_colliding() and sign(_velocity.x) == -1):
		if ($RayCast_right.get_collider().name == "Player"):
			_velocity.x *= -1.0
		

func _on_nav_timer_timeout():
	follow_player()
	
func activate_targets():
	var targets = []
	for path in death_trigger_target_Paths:
		if (path.is_empty() == false):
			targets.append(get_node(path))
	for target in targets:
		target.activate()
	
