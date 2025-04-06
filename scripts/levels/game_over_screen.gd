class_name Game_Over
extends CanvasLayer

signal quit_to_main

func _on_quit_to_menu_pressed() -> void:
	quit_to_main.emit()
	var nodes = get_tree().root.get_children()
	for node in nodes:
		node.queue_free()
	get_tree().change_scene_to_file("res://scenes/levels/title_screen.tscn")

func _on_retry_level_pressed() -> void:
	#TODO: When I know how were doing this
	pass # Replace with function body.
