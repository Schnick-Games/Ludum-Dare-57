class_name MainLevel
extends Node

func _ready() -> void:
	GlobalVariables.time = 0.0

func _process(delta: float) -> void:
	GlobalVariables.time += delta
