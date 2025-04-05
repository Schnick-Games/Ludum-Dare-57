class_name Player
extends CharacterBody2D

@export var gravity: float = 981.0
@export var walk_speed: float = 500.0
@export var jump_velocity: float = 600.0
@export var max_fall_velocity: float = 2000
@export var slide_velocity: float = 150.0

var max_down_velocity: float = max_fall_velocity

@export var max_jumps: int = 2
@export var max_jumps_from_slide: int = 1
var remaining_jumps: int = 1

var touching_wall: bool = false

var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = $AnimatedSprite2D
	
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if !dashing || abs(velocity.x) < walk_speed:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_down_velocity)
	
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
<<<<<<< Updated upstream
=======
	if Input.is_action_just_pressed("Dash") && dash_unlocked && remaining_dashes > 0:
		if sprite.flip_h:
			velocity.x = - dash_velocity
		else:
			velocity.x = dash_velocity
		remaining_dashes -= 1
		dashing = true
		velocity.y = 0
>>>>>>> Stashed changes
	
	move_and_slide()
	handle_move_and_slide_collisions()

func handle_move_and_slide_collisions():
	var floor_collision: bool = false
	var wall_collision: bool = false
	for i in get_slide_collision_count():
		var angle: float = get_slide_collision(i).get_angle()
		if angle == 0.0:
			floor_collision = true
		elif is_equal_approx(angle, PI/2):
			wall_collision = true
	
	if floor_collision:
		remaining_jumps = max_jumps
	if wall_collision:
		max_down_velocity = slide_velocity
		if !touching_wall:
			remaining_jumps = max(remaining_jumps, max_jumps_from_slide)
			touching_wall = true
	else:
		touching_wall = false
		max_down_velocity = max_fall_velocity
