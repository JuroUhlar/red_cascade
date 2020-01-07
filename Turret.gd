extends StaticBody2D

export var deployed = false

func _physics_process(delta):
	if ($RayCast_left.is_colliding() or $RayCast_right.is_colliding()):
		if !deployed: 
			deployed = true		

		if $RayCast_left.is_colliding():
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false		
		
	if deployed: $Sprite.play("deploy")
	

