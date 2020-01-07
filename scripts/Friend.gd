extends StaticBody2D

var player_is_close = false
export (NodePath) var primary_dialogue_path
export (NodePath) var secondary_dialogue_path
var primary_dialogue
var secondary_dialogue
var primary_dialogue_finished = false

func _ready():
	if (primary_dialogue_path.is_empty()):
		print("Primary dialogue path empty")
	else:
		primary_dialogue = get_node(primary_dialogue_path)
		
	if (secondary_dialogue_path.is_empty()):
		print("Secondary dialogue path empty")
	else:
		secondary_dialogue = get_node(secondary_dialogue_path)

func _on_player_proximity_sensor_body_entered(body):
	if(body.is_in_group("player")):
		player_is_close = true
		$Hint.visible = true


func _on_player_proximity_sensor_body_exited(body):
	if(body.is_in_group("player")):
		player_is_close = false
		$Hint.visible = false
		
func _process(delta):
	if(Input.is_action_just_pressed("interact") and player_is_close):
		start_dialogue()
		
func start_dialogue():
	if(!primary_dialogue_finished): 
		primary_dialogue.activate()
		primary_dialogue_finished = true
	else:
		if (!secondary_dialogue_path.is_empty()):
			secondary_dialogue.activate()
