extends StaticBody2D

export var open = false;

func _ready():
	$AnimationPlayer.root_node = ".."
	if (open): open()
	
	

func activate():
	open()
	
func deactivate():
	close()

func open():
	$AnimationPlayer.play("Open")
	# $CollisionShape2D.disabled = true
	$CollisionShape2D.scale = Vector2.ZERO
	open = true
	
func close():
	$AnimationPlayer.play("Close")
	# $CollisionShape2D.disabled = false
	$CollisionShape2D.scale = Vector2.ONE
	open = false
