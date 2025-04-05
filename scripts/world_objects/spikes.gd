class_name Spikes
extends Area2D

@export var respawn_pos: Node2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		var player: Player = body
		player.damage_player(1)
		player.position = respawn_pos.position
	if body is Enemy:
		var enemy: Enemy = body
		enemy.position = respawn_pos.position
		enemy.damage_enemy(1)
