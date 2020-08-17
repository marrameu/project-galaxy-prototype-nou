extends Control


func _ready() -> void:
	$VBoxContainer/NewGameButton.grab_focus()


func _on_PlayButton_pressed() -> void:
	A.play_click()
	get_tree().change_scene("res://src/Levels/Level.tscn")
