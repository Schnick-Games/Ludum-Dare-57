@tool
class_name Floor
extends StaticBody2D

@export var texture: Texture2D

func _on_sprite_ready() -> void:
	$Sprite.texture = texture
