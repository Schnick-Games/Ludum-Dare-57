class_name Enemy
extends CharacterBody2D

var sprite: AnimatedSprite2D

@export var gravity: float = 2000
@export var walk_speed: float = 500.0
@export var max_fall_velocity: float = 2000
@export var damage: int = 1

@export var max_health: int = 2
var health = max_health

var angular_velocity = 0
var rag_dolling: bool = false

func _ready() -> void:
	sprite = $AnimatedSprite2D
	sprite.play("Walk")

func _physics_process(delta: float) -> void:
	rotation_degrees += angular_velocity * delta
	
	velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_velocity)
	
	patrol()
	
	move_and_slide()
	
	check_attack()

func patrol():
	if rag_dolling:
		return
	if !$RayCast2D.is_colliding():
		flip()
	else:
		for i in get_slide_collision_count():
			var angle: float = get_slide_collision(i).get_angle()
			if is_equal_approx(angle, PI/2):
				flip()
	
	velocity.x = walk_speed

func flip():
	sprite.flip_h = !sprite.flip_h
	walk_speed = -walk_speed
	$RayCast2D.position.x = -$RayCast2D.position.x
	$AttackRaycast.position.x = -$AttackRaycast.position.x
	$AttackRaycast.target_position.x = -$AttackRaycast.target_position.x

func hit_enemy(velocity_change: Vector2, damage: int):
	rag_dolling = true
	$RagdollTimer.start()
	velocity = velocity_change
	angular_velocity = rad_to_deg(velocity_change.angle_to(up_direction)) * -5
	damage_enemy(damage)

func damage_enemy(damage: int):
	health -= damage
	if health <= 0:
		die()

func die():
	queue_free()

func _on_ragdoll_timer_timeout() -> void:
	rag_dolling = false
	rotation = 0
	angular_velocity = 0.0

func check_attack():
	if $AttackRaycast.is_colliding():
		var detected_node: Node = $AttackRaycast.get_collider()
		if detected_node is Player:
			var player: Player = detected_node
			player.damage_player(damage)
