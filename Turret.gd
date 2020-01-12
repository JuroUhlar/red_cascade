extends StaticBody2D

export var deployed = false
export var sensor_range = 400
export (PackedScene) var bullet


func _physics_process(delta):
	if ($RayCast_left.is_colliding() or $RayCast_right.is_colliding()):
		if !deployed: 
			$Sprite.play("deploy")
			yield($Sprite, "animation_finished")
			$RayCast_left.cast_to = Vector2(-sensor_range, 0)
			$RayCast_right.cast_to = Vector2(sensor_range, 0)
			deployed = true
		
		if deployed:
			if $RayCast_left.is_colliding():
				$Sprite.flip_h = true
				if sign($muzzle_position.position.x) == 1:
					$muzzle_position.position.x *= -1
			else:
				$Sprite.flip_h = false
				if sign($muzzle_position.position.x) == -1:
					$muzzle_position.position.x *= -1
					
			if $gun_timer.time_left <= 0: 
				shoot()
		
	if deployed: $Sprite.play("deploy")
	
func shoot():
	$gun_timer.start()
	var projectile = bullet.instance()
	if sign($muzzle_position.position.x) == 1:
		projectile.set_projectile_direction(1)
	else:
		projectile.set_projectile_direction(-1)
	get_parent().add_child(projectile)
	projectile.position = $muzzle_position.global_position

