extends Node2D

export (PackedScene) var enemy_boss_scene
export (NodePath) var friendPath
var friend

func _ready():
	if (friendPath.is_empty()):
		print("Friend path empty")
	else:
		friend = get_node(friendPath)
	
func activate():
	var friend_position = friend.global_position
	friend.queue_free()
	
	var enemy_boss = enemy_boss_scene.instance()
	
	add_child(enemy_boss)
	enemy_boss.global_position = friend_position
	

