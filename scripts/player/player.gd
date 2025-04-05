class_name Player
extends CharacterBody2D

@export var gravity: float = 981.0
@export var walk_speed: float = 500.0
@export var jump_velocity: float = 600.0

@export var max_jumps: int = 2
var remaining_jumps: int = 1

var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = $AnimatedSprite2D
	
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if Input.is_action_pressed("ui_left"):
		velocity.x  = -walk_speed
		sprite.flip_h = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = walk_speed
		sprite.flip_h = false
	else:
		velocity.x = 0
	
	if Input.is_action_just_pressed("Jump"):
		if remaining_jumps > 0:
			remaining_jumps -= 1
			velocity.y = -jump_velocity
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_angle() == 0.0:
			remaining_jumps = max_jumps
			break
