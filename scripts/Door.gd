extends StaticBody2D

export var open = false;

func activate():
	open()
	
func deactivate():
	close()


func open():
	$AnimationPlayer.play("Open")
	$CollisionShape2D.disabled = true
	open = true
	
func close():
	$AnimationPlayer.play("Close")
	$CollisionShape2D.disabled = false
	open = false
