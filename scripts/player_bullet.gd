extends Area2D

export var speed = 350
var velocity = Vector2()
var direction = 1

#THIS IS THE NORMAL DAGGER
func set_projectile_direction(dir):
	direction = dir
	if dir == -1:
		$Sprite.flip_h = true

func _physics_process(delta):
	velocity.x = speed * delta * direction
	translate(velocity)

func _on_lifetime_timer_timeout():
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
