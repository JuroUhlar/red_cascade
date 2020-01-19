extends KinematicBody2D

const UP = Vector2(0,-1)
const SPEED = 80


var motion = Vector2()

func _physics_process(_delta):
	
	
	#MOVEMENT
	if Input.is_action_pressed("ui_right"):
			motion.x = SPEED
			$Sprite.flip_h = true
			$Sprite.play("walk")

		
	elif Input.is_action_pressed("ui_left"):
			motion.x = -SPEED
			$Sprite.flip_h = false
			$Sprite.play("walk")

	else:
		motion.x = 0
		$Sprite.play("idle")
		

	if $Sprite.visible == false:
		motion.x = 0
	
	motion = move_and_slide(motion, UP)

func _on_Continue_body_entered(body):
	get_tree().change_scene("res://scenes/Demo_Level.tscn")
	
func _on_Quit_body_entered(body):
	get_tree().quit()

func _on_Timer_timeout():
	$ExplodeDude.play()

func _on_ExplodeDude_animation_finished():
	$Sprite.visible = true
	$ExplodeDude.visible = false