extends Spatial


func _ready() -> void:
	Events.emit_signal("level_changed")


func _process(delta):
	if Input.is_key_pressed(KEY_F1):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_key_pressed(KEY_F2):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()


func finish_interaction():
	Events.emit_signal("end_interaction")

