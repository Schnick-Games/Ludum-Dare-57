extends Control

var main_scene = preload("res://scenes/levels/main.tscn").instantiate()
var seconds = 0.0

func _process(delta: float) -> void:
	var tex: AtlasTexture = $MainMenuContainer/HBoxContainer/CenterContainer/TextureRect.texture
	seconds += delta
	if seconds >= 0.5:
		tex.region.position.x = 256 if tex.region.position.x == 0  else 0 
		seconds = 0.0


func _on_play_pressed() -> void:
	get_tree().root.add_child(main_scene)
	queue_free()


func _on_exit_pressed() -> void:
	get_tree().quit()
