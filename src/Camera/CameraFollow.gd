tool
extends Spatial

export var target : NodePath

var _move_speed : = 6.0
var _rotate_speed : = 1.5

var clamp_angle : = 70.0
var input_sensitivity : = 1.0

enum States { PLAYER, CINEMATIC } # Treure?
var current_state = States.PLAYER

func _get_configuration_warning():
	var warnings : = PoolStringArray()
	
	var has_camera : = false
	for child in get_children():
		if child is Camera:
			has_camera = true
			break
	
	if not has_camera:
		warnings.append("No hi ha cap 'càmara' com a fill")
	if not target:
		warnings.append("No s'ha definit cap 'objectiu'.")
	# shake timer
	
	return warnings.join("\n")


func _process(delta):
	if Engine.editor_hint:
		return
	
	match current_state:
		States.PLAYER:
			var input = Vector2(Input.get_action_strength("camera_up") - Input.get_action_strength("camera_down"),
								Input.get_action_strength("camera_left") - Input.get_action_strength("camera_right"))
			input = input.clamped(1)
			
			rotation += Vector3(input.x, input.y, 0) * _rotate_speed * input_sensitivity * delta
			rotation.x = clamp(rotation.x, deg2rad(-clamp_angle), deg2rad(clamp_angle))
			
			translation = lerp(translation, get_node(target).translation, _move_speed * delta)


func change_state(new_state : int) -> void:
	current_state = new_state
