extends CanvasLayer
class_name GUI

export var player: NodePath

onready var tween: = $Tween
onready var container: = $Container
onready var quest_journal: = $Container/QuestJournal
onready var quest_button: = $Container/QuestButton
onready var animation_player: = $Container/AnimationPlayer

var can_show: = true


func _ready() -> void:
	quest_journal.connect("updated", self, "_wiggle_element", [quest_button])


func _process(delta: float) -> void:
	$Container/QuestButton.visible = can_show
	if can_show:
		if Input.is_action_just_pressed("menu"):
			_on_QuestButton_pressed()
	elif quest_journal.active:
		_on_QuestButton_pressed(false)


func _wiggle_element(element) -> void:
	yield(get_tree().create_timer(0.5), "timeout") # Esperar uns instants
	
	A.play_jingle()
	
	var wiggles = 6
	var offset = Vector2(15, 0)
	var last_position = element.rect_position
	for i in range(wiggles):
		var direction = 1 if i % 2 == 0 else - 1
		tween.interpolate_property(element,
			"rect_position",
			last_position,
			element.rect_position + offset * direction,
			0.05,
			Tween.TRANS_BOUNCE, 
			Tween.EASE_IN,
			i * 0.05)
		last_position = element.rect_position + offset * direction
	tween.interpolate_property(element,
			"rect_position",
			last_position,
			element.rect_position,
			0.05,
			Tween.TRANS_BOUNCE, 
			Tween.EASE_IN,
			wiggles * 0.05)
	tween.start()


func _on_QuestButton_pressed(play_audio : = true):
	if play_audio:
		A.play_click()
	animation_player.play("slide_out_quest_journal" if quest_journal.active else "slide_in_quest_journal")
	quest_journal.active = not quest_journal.active
	if not quest_journal.active:
		quest_button.release_focus()


func hide() -> void:
	container.hide()


func show() -> void:
	container.show()
