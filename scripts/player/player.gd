class_name Player
extends CharacterBody2D

var health_scene: Health = preload("res://scenes/game_hud/health.tscn").instantiate() #TODO: Maybe move elsewhere
var game_over_scene: Game_Over = preload("res://scenes/levels/game_over_screen.tscn").instantiate()

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
var jumping: bool = false

@export var max_health: int = 3
var health

var invincible: bool = false

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
var ray_cast: RayCast2D 

func _ready() -> void:
	health = max_health
	
	sprite = $AnimatedSprite2D
	ray_cast = $RayCast2D
	
	sprite.play("idle")
	
	health_scene.setup_health(get_node("."))
	get_tree().root.add_child.call_deferred(health_scene)

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
				ray_cast.position.x = -abs(ray_cast.position.x)
				ray_cast.target_position.x = -abs(ray_cast.target_position.x)
			elif Input.is_action_pressed("ui_right"):
				velocity.x = walk_speed
				sprite.flip_h = false
				dashing = false
				ray_cast.position.x = abs(ray_cast.position.x)
				ray_cast.target_position.x = abs(ray_cast.target_position.x)
			elif !dashing:
				velocity.x = 0
		if Input.is_action_just_pressed("Jump"):
			if remaining_jumps > 0:
				remaining_jumps -= 1
				velocity.y = -jump_velocity
				jumping = true
		if Input.is_action_just_pressed("Dash") && dash_unlocked && remaining_dashes > 0:
			if sprite.flip_h:
				velocity.x = - dash_velocity
			else:
				velocity.x = dash_velocity
			remaining_dashes -= 1
			dashing = true
			velocity.y = 0
		
		if Input.is_action_just_pressed("Attack") && !dashing:
			attack()
		# collision layer for platforms
		if Input.is_action_just_pressed("ui_down"):
			set_collision_layer_value(2, false)
			set_collision_mask_value(2, false)
		if Input.is_action_just_released("ui_down"):
			set_collision_layer_value(2, true)
			set_collision_mask_value(2, true)
		
	move_and_slide()
	handle_move_and_slide_collisions()

func handle_move_and_slide_collisions():
	var floor_collision: bool = false
	var wall_collision: bool = false
	var ceiling_collision:bool = false
	for i in get_slide_collision_count():
		var angle: float = get_slide_collision(i).get_angle()
		if angle == 0.0:
			floor_collision = true
		elif is_equal_approx(angle, PI/2):
			wall_collision = true
		elif is_equal_approx(angle, PI):
			ceiling_collision = true
	
	if floor_collision:
		remaining_jumps = max_jumps
		if !touching_floor:
			remaining_dashes = max_dash
			$LandingSounds.play()
		touching_floor = true
		jumping = false
	else:
		if touching_floor == true && jumping == false:
			jumping = true
			remaining_jumps -= 1
		touching_floor = false
	
	if wall_collision:
		if wall_slide_unlocked:
			max_down_velocity = slide_velocity
		if !touching_wall:
			if wall_jump_unlocked:
				remaining_jumps = max(remaining_jumps, max_jumps_from_slide)
			touching_wall = true
		
		# stop the jump from breaking when you touch a wall
		if sprite.flip_h:
			position.x += 5
		else:
			position.x -= 5
	else:
		touching_wall = false
		max_down_velocity = max_fall_velocity
	
	if ceiling_collision:
		$HeadBumpSounds.play()

func attack():
	sprite.play("attack forward")
	$AttackTimer.start()
	attacking = true
	$AttackSounds.play()
	
	# raycast fun
	ray_cast.force_raycast_update()
	
	var hit_object = ray_cast.get_collider()
	if hit_object is Enemy:
		(hit_object as Enemy).hit_enemy(ray_cast.target_position.normalized() * 300, 1)
		$AttackHitSound.play()
		$BloodExplosion.global_position = ray_cast.get_collision_point()
		$BloodExplosion.emitting = true
	if hit_object is Boss:
		if (hit_object as Boss).damage_boss():
			$AttackHitSound.play()
		else:
			$DeflectSound.play()

func _on_attack_timer_timeout() -> void:
	sprite.play("idle")
	attacking = false
	
# returns false if this killed the player
func damage_player(damage: int) -> bool:
	if !invincible:
		$DamageEffect.damage_effect()
		$DamageSound.play()
		health -= damage
		if health <= 0:
			die()
			return false
		invincible = true
		$InvincibilityTimer.start()
	return true
		
func die():
	queue_free()
	health_scene.queue_free()
	get_tree().root.add_child(game_over_scene)
	pass

func _on_invincibility_timer_timeout() -> void:
	invincible = false
