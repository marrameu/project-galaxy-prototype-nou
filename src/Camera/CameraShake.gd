extends Camera

onready var timer : Timer = $ShakeTimer

export var amplitude : = 0.025 # 5 seria com un terratrèmol
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.4
export var shake : = false setget set_shake

var enabled : = false


func _ready():
	randomize()
	enabled = false
	self.duration = duration
	timer.connect("timeout", self, "_on_ShakeTimer_timeout")
	Events.connect("shake_camera", self, "_on_shake_requested")


func _process(delta):
	if enabled:
		var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
		v_offset = rand_range(-amplitude, amplitude) * damping
		h_offset = rand_range(-amplitude, amplitude) * damping


func _on_ShakeTimer_timeout() -> void:
	self.shake = false


func _on_shake_requested() -> void:
	if current:
		self.shake = true


func set_duration(value : float) -> void:
	duration = value
	timer.wait_time = duration


func set_shake(value : bool) -> void:
	shake = value
	enabled = shake
	v_offset = 0.0
	h_offset = 0.0
	if shake:
		timer.start()
