class_name Health
extends CanvasLayer

var health_ico: Texture2D = preload("res://art/player/player_health.png")
var health_empty_ico: Texture2D = preload("res://art/player/player_health_empty.png")

var player: Player = null
var icons: Array[TextureRect]

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	for i in player.max_health:
		if i >= player.health:
			icons[i].texture = health_empty_ico
		else:
			icons[i].texture = health_ico
			
	
func create_health_bar():
	var icon: TextureRect = TextureRect.new()
	$HBoxContainer.add_child(icon)
	icon.texture = health_ico
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = Vector2(55, 55)
	icons.push_back(icon)
	pass
	
func setup_health(in_player: Player):
	player = in_player
	for i in in_player.max_health:
		create_health_bar()
