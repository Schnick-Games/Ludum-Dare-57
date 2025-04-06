extends Area2D

@export var boss: Boss
@export var manhole: ManHole

func _ready() -> void:
	manhole.set_open_state(true)
	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		boss.start_battle()
		manhole.set_open_state(false)
