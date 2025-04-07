class_name BossPlatform
extends StaticBody2D

@export var floor: int
@export var left: bool

var destroying: bool = false
var shrink_rate: float = 1.0

func destroy():
	destroying = true

func _process(delta: float) -> void:
	if destroying:
		var shrink_amount = delta * shrink_rate
		scale -= Vector2(shrink_amount, shrink_amount)
		if scale.x < 0:
			queue_free()
