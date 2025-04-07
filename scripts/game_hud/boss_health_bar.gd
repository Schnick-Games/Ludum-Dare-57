class_name BossHealthBar
extends CanvasLayer

var max_health: int:
	set(h):
		max_health = h
		$VBoxContainer/ProgressBar.max_value = h

var health: int:
	set(h):
		health = h
		$VBoxContainer/ProgressBar.value = h
