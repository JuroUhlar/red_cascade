extends Node2D

export (PackedScene) var enemy_scene
export var max_enemies = 25
var counter = 0

func activate():
	$spawn_timer.start()
	
func _on_spawn_timer_timeout():
	var enemy = enemy_scene.instance()
	add_child(enemy)
	enemy.get_node("VisibilityEnabler2D").scale = Vector2(10,5)
	enemy.activate()
	counter += 1
	if (counter > max_enemies): $spawn_timer.stop()
