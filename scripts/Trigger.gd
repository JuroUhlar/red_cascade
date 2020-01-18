extends Area2D

export (NodePath) var targetPath
export var deactivate = false
export var triggerable = true
var target

func _ready():
	if (targetPath.is_empty()):
		print("Target path empty")
	else:
		target = get_node(targetPath)

func _on_Trigger_body_entered(body):
	if (triggerable and body.is_in_group("player")):
		if(deactivate): target.deactivate()
		else: target.activate()
		queue_free()
		
func activate():
	triggerable = true
	
