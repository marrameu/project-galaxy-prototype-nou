extends Node


func get_input_strenght() -> Vector2:
	var input: = Vector2(	Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
							Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward"))
	return input


func load_dialogue(file_path) -> Dictionary:
	var file = File.new()
	assert(file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	var dialogue = parse_json(file.get_as_text())
	assert (dialogue.size() > 0)
	return dialogue
