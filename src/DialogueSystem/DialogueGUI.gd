extends CanvasLayer


func _process(delta):
	if $DialogueSystem.visible:
		layer = 4
	else:
		layer = 0
