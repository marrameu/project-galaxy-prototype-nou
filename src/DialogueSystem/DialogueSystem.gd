extends Control
class_name DialogueSystem

onready var dialogue_player: = $DialoguePlayer
onready var title_label: = $DialogueBox/TitlePanel/Text
onready var text_label: = $DialogueBox/Panel/Text

var waiting: = false


func _ready() -> void:
	Events.connect("start_dialogue", self, "start")
	
	set_process(false)
	hide()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if not waiting:
			A.play_click()
			dialogue_player.next()
			update_content()


func start(dialogue: Dictionary) -> void:
	dialogue_player.start(dialogue)
	set_process(true)
	
	update_content()
	show()


func update_content() -> void:
	title_label.text = dialogue_player.title
	text_label.text = dialogue_player.text


func _on_DialoguePlayer_finished() -> void:
	set_process(false)
	hide()


func _on_DialoguePlayer_started_waiting():
	waiting = true
	hide()


func _on_DialoguePlayer_finished_waiting():
	waiting = false
	dialogue_player.next()
	update_content()
	show()

