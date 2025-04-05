extends CanvasLayer

signal opened_pause
signal quit_to_main

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		opened_pause.emit()

func _on_continue_pressed() -> void:
	get_tree().paused = false
	visible = false


func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	visible = false
	quit_to_main.emit()
	var nodes = get_tree().root.get_children()
	for node in nodes:
		node.queue_free()
	get_tree().change_scene_to_file("res://scenes/levels/title_screen.tscn")
