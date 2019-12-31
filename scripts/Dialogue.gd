extends Control


export (String) var text = "default dialogue text"
export (Texture) var avatarTexture 
 

onready var button = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/Button")
onready var line = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer2/Line")
onready var avatar = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Avatar")

var dismissable = false

func _ready():
	line.text = text
	avatar.texture = avatarTexture

func _on_Button_pressed():
	pressed()
	
func activate():
	visible = true
	get_tree().paused = true
	$dismissable_timer.start()
	button.grab_focus()
	
func _process(delta):
	if(dismissable and Input.is_action_pressed("interact")):
		pressed()

func pressed():
	visible = false
	dismissable = false
	get_tree().paused = false

func _on_dismissable_timer_timeout():
	dismissable = true
