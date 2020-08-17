extends Action
class_name CompleteQuestAction

export var quest_reference: PackedScene
var quest: Quest = null

var completed: = false


func _ready() -> void:
	assert(quest_reference)
	quest = QuestSystem.find_quest(quest_reference.instance())
	quest.connect("completed", self, "_on_Quest_completed")
	quest.connect("delivered", self, "_on_Quest_delivered")


func _on_Quest_completed() -> void:
	print("completed")
	completed = true
	emit_signal("finished", 1)


func _on_Quest_delivered() -> void:
	emit_signal("finished", 2)


func interact() -> void:
	print("delivered")
	QuestSystem.deliver(quest)
