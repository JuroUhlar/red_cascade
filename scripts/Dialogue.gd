extends Control

export (Array, String) var texts = ["default dialogue text 1"]
export (Array, Texture) var avatarTextures
export (Array, NodePath) var end_trigger_target_Paths
export var start_delay = 0


onready var button = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer2/Button")
onready var line = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer2/Line")
onready var avatar = get_node("Panel/MarginContainer/VBoxContainer/HBoxContainer/CenterContainer/Avatar")


var dismissable = false
var lineCount = 1
var lineIndex = 0
var targets = []

func _ready():
	for path in end_trigger_target_Paths:
		if (path.is_empty() == false):
			targets.append(get_node(path))
	lineCount = texts.size()
	updateDialogue()

func _on_Button_pressed():
	pressed()
	
func _process(delta):
	if(dismissable and Input.is_action_just_released("interact")):
		pressed()

func activate():
	if start_delay > 0:
		$delay_timer.wait_time = start_delay
		$delay_timer.start()
	else:
		start_dialogue()

func pressed():
	if lineIndex < lineCount - 1:
		lineIndex += 1
		updateDialogue()
	else:	
		closeDialogue()

func _on_dismissable_timer_timeout():
	dismissable = true
			
func updateDialogue():
	line.text = texts[lineIndex]
	button.text = getButtonText()
	avatar.texture = avatarTextures[lineIndex]
	
func start_dialogue():
	visible = true
	get_tree().paused = true
	updateDialogue()
	$dismissable_timer.start()
	button.grab_focus()
	
func getButtonText():
	if lineIndex == lineCount - 1:
		return "Close"
	else:
		return "Next"

func closeDialogue():
	visible = false
	dismissable = false
	lineIndex = 0
	get_tree().paused = false
	if(targets):
		for target in targets:
			target.activate()
	
func _on_delay_timer_timeout():
	start_dialogue()
