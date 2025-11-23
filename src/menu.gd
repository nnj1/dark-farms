extends Node2D

func _ready() -> void:
	GlobalVars.change_cursor()

func _on_button_3_pressed() -> void:
	get_tree().quit()

func _on_button_2_pressed() -> void:
	$ui/FileDialog.popup_centered()


func _on_file_dialog_file_selected(_path: String) -> void:
	# TODO Load the game
	pass # Replace with function body.

func _on_button_pressed() -> void:
	GlobalVars.in_game = true
	get_tree().change_scene_to_file("res://scenes/main.tscn")
