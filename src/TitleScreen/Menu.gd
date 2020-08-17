extends Control


func _ready() -> void:
	$VBoxContainer/NewGameButton.grab_focus()


func _on_PlayButton_pressed() -> void:
	A.play_click()
	get_tree().change_scene("res://src/Levels/Level.tscn")


func _on_ExitButton_pressed():
	get_tree().quit()
