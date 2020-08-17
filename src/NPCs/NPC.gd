extends StaticBody
class_name NPC

export (int) var npc_id: = 1 # name -> "npc1" / "kylo_ren"

onready var actions: = $Actions
onready var quest_bubble: = $QuestBubble

onready var animation_player: = $PlayerMesh/AnimationPlayer

var current_state: = 0


func _ready() -> void:
	Events.connect("start_interaction", self, "_interact")
	Events.connect("end_interaction", self, "_end_interaction")
	
	var quest_actions : Array = []
	for child in actions.get_children():
		if not child.is_in_group("quest_actions"):
			continue
		for action in child.get_children():
			if not (action is GiveQuestAction or action is CompleteQuestAction):
				continue
			quest_actions.append(action)
	if quest_actions.size() == 0:
		return
	quest_bubble.initialize(quest_actions)


func _interact(npc_path: NodePath) -> void: # args com _end_interaction?
	if npc_path == get_path():
		for body in $Area.get_overlapping_bodies():
			if body is Player:
				look_at(body.translation, Vector3.UP)
				rotation = Vector3(0, rotation.y - deg2rad(180 + 15), 0)
		
		A.play_click()
		animation_player.play("talking")
		actions.get_node("PlayDialogueAction").interact(current_state)


func _end_interaction(args: Array) -> void:
	if args[0] == ("npc" + str(npc_id)):
		animation_player.play("idle")
		if args.size() > 2:
			if args[1] == "give_quest":
				actions.get_node("QuestActions" + args[2] + "/GiveQuestAction").interact()
			elif args[1] == "complete_quest":
				actions.get_node("QuestActions" + args[2] + "/CompleteQuestAction").interact()


func _on_Action_finished(new_state: int) -> void:
	current_state = new_state
