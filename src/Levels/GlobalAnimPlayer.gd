extends AnimationPlayer


func _ready() -> void:
	Events.connect("play_global_anim", self, "play")
