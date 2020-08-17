"""
Provides a simple API to start and to deliver quests, using the start() and
deliver() methods respectively.
Uses 4 QuestContainer nodes to stores all available, active, completed,
and delivered (finished) quests.
"""
extends Node

onready var available_quests = $Available
onready var active_quests = $Active
onready var completed_quests = $Completed
onready var delivered_quests = $Delivered


func initialize(player: Player) -> void:
	pass


func find_available(reference: Quest) -> Quest:
	"""
	Returns the Quest corresponding to the reference instance,
	to track its state or connect to it
	"""
	return available_quests.find(reference)


func find_quest(reference: Quest) -> Quest:
	var quest: Quest = null
	for child in get_children():
		quest = child.find(reference)
		if quest:
			break
	return quest


func get_available_quests() -> Array: # TEMPORAL?
	"""
	Returns an Array of all quests under the Available node
	"""
	return available_quests.get_quests()


func get_all_quests() -> Array:
	var quests: = Array()
	for child in get_children():
		if child.has_method("get_quests"):
			quests += child.get_quests()
	return quests


func is_available(reference : Quest) -> bool:
	return available_quests.find(reference) != null


func start(reference : Quest):
	var quest : Quest = available_quests.find(reference)
	quest.connect("completed", self, "_on_Quest_completed", [quest])
	available_quests.remove_child(quest)
	active_quests.add_child(quest)
	quest._start()


func _on_Quest_completed(quest):
	if completed_quests.is_a_parent_of(quest):
		return
	active_quests.remove_child(quest)
	completed_quests.add_child(quest)


func deliver(quest : Quest):
	"""
	Marks the quest as complete, rewards the player,
	and removes it from completed quests
	"""
	quest._deliver()

	var rewards = quest.get_rewards()
	print(rewards)
	
	"""
	Que en comptes de party, el autload de desar i carregar s'encarregui
	
	for item in rewards['items']:
		party.inventory.add(item.item, item.amount)
	for party_member in party.get_active_members():
		party_member.experience += rewards['experience']
	"""

	assert(quest.get_parent() == completed_quests)
	completed_quests.remove_child(quest)
	delivered_quests.add_child(quest)
