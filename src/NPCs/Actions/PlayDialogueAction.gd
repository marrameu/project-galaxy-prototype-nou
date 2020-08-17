extends Action
class_name PlayDialogueAction

export (Array, String, FILE, "*.json") var dialogues_files_paths


func _ready() -> void:
	assert(dialogues_files_paths)


func interact(index: int) -> void:
	print("play dialogue")
	play_dialogue(index)


func play_dialogue(index: int) -> void:
	var dialogue : Dictionary = U.load_dialogue(dialogues_files_paths[index])
	Events.emit_signal("start_dialogue", dialogue)
	emit_signal("finished", index)
