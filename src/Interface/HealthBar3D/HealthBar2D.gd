extends TextureProgress

var bar_red = preload("res://assets/interface/healthbar_red.png")
var bar_green = preload("res://assets/interface/healthbar_green.png")
var bar_yellow = preload("res://assets/interface/healthbar_yellow.png")


func _ready():
	value = 100

func update_bar(new_value):
	texture_progress = bar_green
	if new_value < max_value * 0.7:
		texture_progress = bar_yellow
	if new_value < max_value * 0.35:
		texture_progress = bar_red
	if new_value < max_value:
		show()
	value = new_value
