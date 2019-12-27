extends Actor

export var speed = Vector2(100,200)


func _ready():
	_velocity.x = -speed.x
	set_physics_process(false)
	add_to_group("enemies")

func _physics_process(delta):
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -1.0
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y
	
	if sign(_velocity.x) == 1:
		$Sprite.flip_h = true
	else: 
		$Sprite.flip_h = false





