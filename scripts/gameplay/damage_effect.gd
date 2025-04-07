extends Timer

@export var sprite: Node2D

func damage_effect():
	sprite.modulate = Color(1,0.6,0.6,1)
	start()

func _on_timeout() -> void:
	sprite.modulate = Color(1,1,1,1)
