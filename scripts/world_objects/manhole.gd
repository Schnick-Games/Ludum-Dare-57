extends StaticBody2D

func _ready() -> void:
	set_open_state(false)

func set_open_state(open: bool):
	if open:
		$AnimatedSprite2D.play_backwards()
		$CollisionShape2D.disabled = true
	else:
		$AnimatedSprite2D.play()
		$CollisionShape2D.disabled = false
