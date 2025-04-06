@tool
extends Area2D

@export var texture: Texture2D

@export var unlock_double_jump: bool = false
@export var unlock_dash: bool = false
@export var unlock_wall_slide: bool = false
@export var unlock_wall_jump: bool = false

var time: float = 0

func _ready() -> void:
	$Sprite2D.texture = texture

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		(body as Enemy).die()
	elif body is Player:
		var player: Player = body
		if unlock_double_jump:
			player.double_jump_unlocked = true
		if unlock_dash:
			player.dash_unlocked = true
		if unlock_wall_slide:
			player.wall_slide_unlocked = true
		if unlock_wall_jump:
			player.wall_jump_unlocked = true
		queue_free()

func _process(delta: float) -> void:
	time += delta
	$Sprite2D.position.y = cos(time * 3) * 10
