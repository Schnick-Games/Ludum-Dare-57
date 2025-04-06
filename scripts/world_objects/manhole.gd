class_name ManHole
extends StaticBody2D

func _ready() -> void:
	set_open_state(false)

func set_open_state(open: bool):
	if open:
		$CollisionShape2D.set_deferred("disabled", true)
		$AnimatedSprite2D.play_backwards()
	else:
		$CollisionShape2D.set_deferred("disabled", false)
		$AnimatedSprite2D.play()
