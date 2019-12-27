extends Actor

export var speed = Vector2(100,200)
export var hp = 30

var dying = false

func _ready():
	_velocity.x = -speed.x
	set_physics_process(false)
	add_to_group("enemies")
	add_to_group("damageable")

func _physics_process(delta):
	if(dying):
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






