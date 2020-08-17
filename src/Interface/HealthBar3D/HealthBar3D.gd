extends Sprite3D

onready var bar = $Viewport/HealthBar2D


func _ready():
	texture = $Viewport.get_texture()


func update(value):
	bar.update_bar(value)
