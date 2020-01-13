extends Area2D

export (NodePath) var dialog_path
var dialog_node

func _ready():
	if (dialog_path.is_empty()):
		print("Dialog path empty")
	else:
		dialog_node = get_node(dialog_path)

func _on_Dash_upgrade_body_entered(body):
	if(body.is_in_group("player")):
		body.get_dash()
		$AnimationPlayer.play("picked_up")
		yield($AnimationPlayer, "animation_finished")
		dialog_node.activate()
		queue_free()

