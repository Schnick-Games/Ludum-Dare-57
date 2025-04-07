extends CanvasLayer

signal quit_to_main

func _ready() -> void:
	var time_string: String = str(int(floor(GlobalVariables.time /60.0)))
	time_string += ":"
	var seconds: float = snapped(fmod(GlobalVariables.time, 60), 0.01)
	if seconds < 10.0:
		time_string += "0"
	time_string += str(seconds)
	$MarginContainer/VBoxContainer/Time.text = "Time: " + time_string

func _on_replay_pressed() -> void:
	var main = get_tree().root.get_node("Main")
	get_tree().root.remove_child(main)
	
	var main_scene_level = load("res://scenes/levels/main.tscn")
	var main_scene = main_scene_level.instantiate()
	get_tree().root.add_child(main_scene)
	queue_free()

func _on_quit_to_menu_pressed() -> void:
	quit_to_main.emit()
	var nodes = get_tree().root.get_children()
	for node in nodes:
		node.queue_free()
	get_tree().change_scene_to_file("res://scenes/levels/title_screen.tscn")
