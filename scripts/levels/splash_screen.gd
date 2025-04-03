extends Node

#var title_scene = preload("res://levels/title_screen.tscn").instantiate()

func _on_timer_timeout() -> void:
	#get_tree().root.add_child(title_scene)
	#get_node("/root/SplashScreen").queue_free()
	get_tree().quit()
