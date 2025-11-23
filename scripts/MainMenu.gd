class_name MainMenu extends Node


func _on_new_game_button_pressed() -> void:
	print("new game")

func _on_load_game_button_pressed() -> void:
	print("load game")

func _on_exit_button_pressed() -> void:
	get_tree().quit(0)
