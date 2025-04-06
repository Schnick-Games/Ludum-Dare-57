extends Node2D

@export var amp = 2
@export var speed = 4
var time = 0.0
var default_pos = Vector2(0,0)

func _ready() -> void:
	default_pos = position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health += 1
		queue_free()

func _physics_process(delta: float) -> void:
	time += delta * speed
	var bob_position = Vector2(0, sin(time) * amp)
	set_position(default_pos + bob_position)
