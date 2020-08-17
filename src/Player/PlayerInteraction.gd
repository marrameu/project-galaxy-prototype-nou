extends Spatial

onready var player: KinematicBody = get_parent()

var target: NodePath = "" # -> Objecte

const FOV: = 80

func _ready():
	Events.connect("end_interaction", self, "finish")


func _process(delta: float) -> void:
	var new_target: = NodePath()
	for body in $Area.get_overlapping_bodies():
		if body is NPC:
			var PB = (body.translation - player.translation).normalized()
			if rad2deg(PB.dot(player.get_global_transform().basis.z)) > FOV / 2:
				new_target = body.get_path()
	target = new_target
	
	$InteractTexture.visible = true if target and player.current_state != player.States.CINEMATIC else false


func interact() -> void:
	if not target or not player.has_contact:
		return
	
	if get_node(target) is NPC:
		Events.emit_signal("start_interaction", target)
		player.change_state(player.States.CINEMATIC)


func finish(msg) -> void:
	player.change_state(player.States.INTERACT)
