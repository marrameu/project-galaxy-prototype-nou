extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("pause_game", self, "pause_or_resume_game")


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		Events.emit_signal("pause_game")


func _on_ButtonContinue_pressed():
	Events.emit_signal("pause_game")


func _on_ButtonOptions_pressed():
	pass # Replace with function body.


func _on_ButtonExit_pressed():
	get_tree().quit()


func pause_or_resume_game():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
