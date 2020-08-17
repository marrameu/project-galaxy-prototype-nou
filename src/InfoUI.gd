extends Control


func _ready():
	pass


func _process(delta):
	$FPSLabel.text = str(Engine.get_frames_per_second())
