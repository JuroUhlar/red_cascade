extends Area2D



func _on_Dash_upgrade_body_entered(body):
	if(body.is_in_group("player")):
		body.get_dash()
		$AnimationPlayer.play("picked_up")
		yield($AnimationPlayer, "animation_finished")
		queue_free()

