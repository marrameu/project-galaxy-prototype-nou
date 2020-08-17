extends Control

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
