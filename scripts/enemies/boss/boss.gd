class_name Boss
extends Area2D

const WIN_SCREEN: Resource = preload("res://scenes/levels/win_screen.tscn")
const HEALTH_BAR: Resource = preload("res://scenes/game_hud/boss_health_bar.tscn")

var health_bar: BossHealthBar 

var sprite: AnimatedSprite2D

var shaking: bool = false
var time: float = 0

var health: int = 9

var attack_count:int = 0
var attacks_until_weak: int = 3
var max_damage_while_weak: int = 3
var remaining_damage: int = 3
var is_weak: bool = false

func start_battle():
	$Timer.start()
	
	health_bar = HEALTH_BAR.instantiate()
	get_tree().root.add_child(health_bar)
	health_bar.max_health = health
	health_bar.health = health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if shaking:
		sprite.position.x = 20 * (cos(time * 17) + cos(time * 7))

func die():
	health_bar.queue_free()
	var win_screen = WIN_SCREEN.instantiate()
	get_tree().root.add_child(win_screen)

func attack(floor: int, left_side: bool):
	attack_count += 1
	sprite.frame = floor
	sprite.flip_h = left_side
	shaking = true
	$ShakeTimer.start()

func _on_timer_timeout() -> void:
	if attack_count >= attacks_until_weak:
		is_weak = true
		remaining_damage = max_damage_while_weak
		attack_count = 0
		$Timer.start(5)
		sprite.frame = 3
	else:
		is_weak = false
		attack(randi_range(0, 2), randi_range(0, 1))

func _on_shake_timer_timeout() -> void:
	shaking = false
	sprite.position = Vector2(0,0)

# returns true if damage happened
func damage_boss() -> bool:
	if is_weak:
		health -= 1
		health_bar.health = health
		$DamageEffect.damage_effect()
		$DamageSound.play()
		remaining_damage -= 1
		if health <= 0:
			die()
			return true
		if remaining_damage <= 0:
			$Timer.start(0.001)
	return false
