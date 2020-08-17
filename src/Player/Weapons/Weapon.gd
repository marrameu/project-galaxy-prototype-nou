"""
Passar 'body_entered' a 'get_overlapping_bodies' i amb 
un raycast per quan hi hagin pocs FPS.
"""
extends Area


func _ready():
	connect("body_entered", self, "_on_body_entered")


func _on_body_entered(body):
	if body is Enemy:
		$AudioStreamPlayer.play()
		Input.start_joy_vibration(0, 0.5, 0.5, 0.2)
		Events.emit_signal("shake_camera")
		
		body.take_damage(1)
