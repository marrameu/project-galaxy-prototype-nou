"""
Represents a quest the player can take on
Uses child Objective nodes to track tasks the player has to complete
And Questitem
"""
extends Node
class_name Quest

signal started()
signal completed()
signal delivered()

enum States { AVALIABLE, ACTIVE, COMPLETED, DELIVERED }
var current_state: = 0

onready var objectives = $Objectives

export var title : String
export var description : String

export var reward_on_delivery : bool = false
export var _reward_experience : int
onready var _reward_items : Node = $ItemRewards


func _ready() -> void:
	Events.connect("level_changed", self, "initialize")


# Desar i carregar
# MILLORAR!
func initialize() -> void:
	print("save/load")
	match current_state:
		States.ACTIVE:
			notify_slay_objectives() # _start()
			emit_signal("started")
		States.COMPLETED:
			emit_signal("completed") # _on_Objective_completed
		States.DELIVERED:
			emit_signal("delivered") # Com fer que no et donguin les recompenses. Ja funciona bé?


func _start():
	for objective in get_objectives():
		objective.connect("completed", self, "_on_Objective_completed")
	notify_slay_objectives()
	current_state = States.ACTIVE
	emit_signal("started")


func get_objectives():
	return objectives.get_children()


func get_completed_objectives():
	var completed : Array = []
	for objective in get_objectives():
		if not objective.completed:
			continue
		completed.append(objective)
	return completed


func _on_Objective_completed(objective) -> void:
	if get_completed_objectives().size() == get_objectives().size():
		current_state = States.COMPLETED
		emit_signal("completed")


func _deliver() -> void:
	current_state = States.DELIVERED
	emit_signal("delivered")


func notify_slay_objectives() -> void:
	for objective in get_objectives():
		# if not objective is QuestSlayObjective: continue
		if objective.has_method("connect_signals"):
			objective.connect_signals() # (objective as QuestSlayObjective).connect_signals()


func get_rewards() -> Dictionary:
	"""
	Returns the rewards from the quest as a dictionary
	"""
	return {
		'experience' : _reward_experience, # int
		'items': _reward_items.get_children() # Array of Item
	}


func get_rewards_as_text() -> Array:
	return [] # temporal
	var text : = []
	text.append(" - Experience: %s" % str(_reward_experience))
	for item in _reward_items.get_children():
		text.append(" - [%s] x (%s)\n" % [item.item.name, str(item.amount)])
	return text
