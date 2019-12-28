extends Area2D

var player_is_close = false
export var active = false
export var toggle = true
export (NodePath) var targetPath
var target = null
var targetPathAbsolute = ""

func _ready():
	if (!active):
		$Sprite.play("default")
		
	if (targetPath.is_empty()):
		print("Target path empty")
	else:
		target = get_node(targetPath)
		targetPathAbsolute = target.get_path()

func _on_Button_body_entered(body):
	if(body.is_in_group("player")):
		player_is_close = true

func _on_Button_body_exited(body):
	if(body.is_in_group("player")):
		player_is_close = false
		
func _process(delta):
	if(Input.is_action_just_pressed("interact") and player_is_close):
		press()
		
func press():
	if(!toggle) and !active:
		activate()
	if(toggle):
		if(active): deactivate()
		else: activate() 
		
func activate():
	$Sprite.play("activate")
	active = true
	if(target_exists() and target.has_method("activate")):
		target.activate()
	
func deactivate():
	$Sprite.play("default")
	active = false
	if(target_exists() and target.has_method("deactivate")):
		target.deactivate()
		
func target_exists():
	return get_tree().get_root().has_node(targetPathAbsolute)
	


