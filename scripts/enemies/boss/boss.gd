class_name Boss
extends Area2D

var sprite: AnimatedSprite2D

var shaking: bool = false

var time: float = 0

func start_battle():
	$Timer.start()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $AnimatedSprite2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if shaking:
		sprite.position.x = 20 * (cos(time * 17) + cos(time * 7))

func die():
	#Show victory screen
	pass

func attack(floor: int, left_side: bool):
	sprite.frame = floor
	sprite.flip_h = left_side
	shaking = true
	$ShakeTimer.start()


func _on_timer_timeout() -> void:
	attack(randi_range(0, 2), randi_range(0, 1))


func _on_shake_timer_timeout() -> void:
	shaking = false
	sprite.position = Vector2(0,0)
