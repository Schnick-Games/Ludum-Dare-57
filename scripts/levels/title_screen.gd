extends Control

var main_scene = preload("res://scenes/levels/main.tscn").instantiate()

func _on_play_pressed() -> void:
	get_tree().root.add_child(main_scene)
	queue_free()


func _on_exit_pressed() -> void:
	get_tree().quit()
