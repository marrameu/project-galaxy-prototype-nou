extends Node
class_name PlayerGUI

onready var player: Player = get_parent()
onready var quest_gui: GUI = $GUI


func _process(delta : float) -> void:
	quest_gui.can_show = !player.current_state != player.States.INTERACT
