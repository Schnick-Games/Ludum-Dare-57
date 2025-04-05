class_name Player
extends CharacterBody2D

@export var gravity: float = 981.0
@export var walk_speed: float = 500.0
@export var jump_velocity: float = 600.0
@export var max_fall_velocity: float = 2000
@export var slide_velocity: float = 150.0
@export var dash_velocity: float = 850.0
#for dash
@export var horizontal_drag: float = 850.0

var max_down_velocity: float = max_fall_velocity

@export var max_jumps: int = 1
@export var max_dash: int = 1
@export var max_jumps_from_slide: int = 1
var remaining_jumps: int = 1
var remaining_dashes: int = 1

var touching_wall: bool = false
var touching_floor: bool = false
var dashing: bool = false
var attacking: bool = false

@export_group("Player Unlock")
@export var double_jump_unlocked: bool = false:
	set(b):
		double_jump_unlocked = b
		if b:
			max_jumps = 2
		else:
			max_jumps = 1
@export var wall_jump_unlocked: bool = false
@export var wall_slide_unlocked: bool = false
@export var dash_unlocked: bool = false
@export_group("")


var sprite: AnimatedSprite2D

func _ready() -> void:
	sprite = $AnimatedSprite2D
	
	sprite.play("idle")

func _physics_process(delta: float) -> void:
	if !dashing || abs(velocity.x) < walk_speed:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_down_velocity)
	
	if dashing:
		var direction: float = -1 if sprite.flip_h else 1
		var decelarate_amount: float = direction * horizontal_drag * delta
		if abs(decelarate_amount) > abs(velocity.x):
			dashing = false
		else:
			velocity.x -= decelarate_amount
	
	if !attacking:
		if !dashing || abs(velocity.x) < walk_speed:	
			if Input.is_action_pressed("ui_left"):
				velocity.x  = -walk_speed
				sprite.flip_h = true
				dashing = false
			elif Input.is_action_pressed("ui_right"):
				velocity.x = walk_speed
				sprite.flip_h = false
				dashing = false
			elif !dashing:
				velocity.x = 0
		if Input.is_action_just_pressed("Jump"):
			if remaining_jumps > 0:
				remaining_jumps -= 1
				velocity.y = -jump_velocity
		if Input.is_action_just_pressed("Dash") && dash_unlocked && remaining_dashes > 0:
			if sprite.flip_h:
				velocity.x = - dash_velocity
			else:
				velocity.x = dash_velocity
			remaining_dashes -= 1
			dashing = true
			velocity.y = 0
		
		if Input.is_action_just_pressed("Attack") && !dashing:
			sprite.play("attack forward")
			$AttackTimer.start()
			attacking = true
			$AttackSounds.play()
		
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
		if !touching_floor:
			remaining_dashes = max_dash
			$LandingSounds.play()
		touching_floor = true
	else:
		touching_floor = false
	if wall_collision:
		if wall_slide_unlocked:
			max_down_velocity = slide_velocity
		if !touching_wall:
			if wall_jump_unlocked:
				remaining_jumps = max(remaining_jumps, max_jumps_from_slide)
			touching_wall = true
	else:
		touching_wall = false
		max_down_velocity = max_fall_velocity


func _on_attack_timer_timeout() -> void:
	sprite.play("idle")
	attacking = false
