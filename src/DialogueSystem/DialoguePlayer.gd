extends Node
class_name DialoguePlayer

signal started()
signal finished()

signal started_waiting()
signal finished_waiting()

onready var timer: = ($Timer as Timer)

var title: String = ""
var text: String = ""

var _conversation:  Array
var _index_current: int = 0

var waiting: = false


func start(dialogue_dict : Dictionary) -> void:
	emit_signal("started")
	_conversation = dialogue_dict.values()
	_index_current = 0
	_update()


func next() -> void:
	_index_current += 1
	assert(_index_current <= _conversation.size())
	_update()


func _update() -> void:
	if _index_current == _conversation.size():
		emit_signal("finished")
		return
	
	var type: = int(_conversation[_index_current].type)
	
	match type:
		1:
			text = _conversation[_index_current].text
			title = _conversation[_index_current].name
		2:
			# Decisió
			pass
		3:
			Events.emit_signal("play_global_anim", _conversation[_index_current].anim)
			next()
		4:
			timer.wait_time = _conversation[_index_current].time
			timer.start()
			emit_signal("started_waiting")
		5:
			# Gallet
			# Exs.: Canviar el mode de la càmera, teleportar al jugador
			# Events.emit_signal("cinematic_trigger", ...)
			pass
		6:
			Events.emit_signal("end_interaction", Array(_conversation[_index_current].args))
			next() # Per amagar el diàleg


func _on_Timer_timeout() -> void:
	emit_signal("finished_waiting")
