extends Node2D

export (Array, NodePath) var trigger_target_Paths

func _on_Timer_timeout():
	activate_targets()
	
func activate_targets():
	var targets = []
	for path in trigger_target_Paths:
		if (path.is_empty() == false):
			targets.append(get_node(path))
	for target in targets:
		target.activate()
