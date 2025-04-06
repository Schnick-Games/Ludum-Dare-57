class_name Spikes
extends Area2D

@export var respawn_pos: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		if player.damage_player(1):
			player.global_position = respawn_pos.global_position
	if body is Enemy:
		var enemy: Enemy = body
		enemy.global_position = respawn_pos.global_position
		enemy.damage_enemy(1)
