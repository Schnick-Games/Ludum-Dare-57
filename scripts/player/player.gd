class_name Player
extends CharacterBody2D

@export var gravity: float = 981.0
@export var walk_speed: float = 500.0
@export var jump_velocity: float = 600.0

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
		velocity.y = -jump_velocity
	
	move_and_slide()
