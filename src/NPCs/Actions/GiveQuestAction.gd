extends Action
class_name GiveQuestAction

export var quest_reference: PackedScene
var quest: Quest = null


func _ready() -> void:
	assert(quest_reference)
	quest = QuestSystem.find_quest(quest_reference.instance())
	quest.connect("started", self, "_on_Quest_started")


func _on_Quest_started() -> void:
	print("started")


func interact() -> void:
	var quest: Quest = quest_reference.instance()
	if not QuestSystem.is_available(quest):
		return
	QuestSystem.start(quest)
