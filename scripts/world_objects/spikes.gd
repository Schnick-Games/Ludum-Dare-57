class_name Spikes
extends Area2D

@export var respawn_pos: Node2D

var enabled: bool = true

func set_enabled(is_enabled: bool):
	enabled = is_enabled
	$Sprite2D.visible = is_enabled

func _on_body_entered(body: Node2D) -> void:
	if !enabled:
		return
	if body is Player:
		var player: Player = body
		if player.damage_player(1):
			player.global_position = respawn_pos.global_position
	if body is Enemy:
		var enemy: Enemy = body
		enemy.global_position = respawn_pos.global_position
		enemy.call_deferred("damage_enemy",1)
