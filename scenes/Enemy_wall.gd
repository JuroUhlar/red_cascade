extends StaticBody2D

export var active = true
export var wall_on_right = false

func _ready():
	if(wall_on_right):
		$Sprite.flip_h = false
		$CollisionShape2D.position.x *= -1
	if(!active):
		visible = false
		$CollisionShape2D.scale = Vector2.ZERO
		$CollisionShape2D.disabled = true
		
func activate():
	visible = true
	$CollisionShape2D.disabled = false
	$CollisionShape2D.scale = Vector2.ONE

