@tool
class_name Key
extends Area2D

@export var manhole: ManHole

var time: float = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	$Sprite2D.position.y = cos(time * 3) * 10

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		manhole.set_open_state(true)
		queue_free()
