extends Control

export var player: NodePath # El pare d'escena? com en el curs


func _ready() -> void:
	pass


func _process(delta : float) -> void:
	var has_contact = str(get_node(player).has_contact)
	var raycast = str(get_node(player).get_node("Tail").is_colliding())
	var running = str(Input.is_action_pressed("run"))
	var can_jump = str(get_node(player)._can_jump)
	
	var current_state = str(get_node(player).current_state)
	
	var text = ("Controller:" + "\nhas_contact: " + has_contact + "\nrayacast: " + raycast + "\nrunning: " + running
	+ "\ncan_jump: " + can_jump + "\n\nState Machine:" + "\ncurrent_state: " + current_state)
	
	var move_input = U.get_input_strenght()
	var camera_input = Vector2(Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left"),
						Input.get_action_strength("camera_down") - Input.get_action_strength("camera_up"))
	
	move_input = move_input.normalized()
	camera_input = camera_input.clamped(1)
	
	$Panel/Label.text = text
	$MoveJoyPanel/Point.rect_position = move_input * 45 + Vector2(30, 30)
	$CameraJoyPanel/Point.rect_position = camera_input * 45 + Vector2(30, 30)
