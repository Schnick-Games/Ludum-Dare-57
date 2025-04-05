class_name Spikes
extends Area2D

@export var respawn_pos: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		# damage player
		player.position = respawn_pos.position
