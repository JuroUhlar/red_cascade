extends Control


export (Array, String) var texts = ["default dialogue text 1"]
export (Texture) var avatarTexture

onready var button = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/Button")
onready var line = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer2/Line")
onready var avatar = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Avatar")

var dismissable = false
var lineCount = 1
var lineIndex = 0 

func _ready():
	lineCount = texts.size()
	line.text = texts[0]
	avatar.texture = avatarTexture
	button.text = getButtonText()

func _on_Button_pressed():
	pressed()
	
func activate():
	visible = true
	get_tree().paused = true
	line.text = texts[lineIndex]
	button.text = getButtonText()
	$dismissable_timer.start()
	button.grab_focus()

func _process(delta):
	if(dismissable and Input.is_action_just_released("interact")):
		pressed()

func pressed():
	if lineIndex < lineCount - 1:
		lineIndex += 1
		line.text = texts[lineIndex]
		button.text = getButtonText()
	else:	
		visible = false
		dismissable = false
		lineIndex = 0
		get_tree().paused = false

func _on_dismissable_timer_timeout():
	dismissable = true
	
func getButtonText():
	if lineIndex == lineCount - 1:
		return "Close"
	else:
		return "Next"
