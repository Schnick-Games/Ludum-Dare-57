@tool
extends Node2D

@export var floor_tile_scene: PackedScene
@export var repeat_x: int = 64
@export var repeat_y: int = 16
@export var tile_size: Vector2 = Vector2(128, 128)

@export var entranceX: int = 1
@export var entranceY: int = 0

var exitX: int
var exitY: int

var offset = 64

#func _ready():
	#exitX = repeat_x - 2
	#exitY = repeat_y - 1 
#
	#for y in range(repeat_y):
		#for x in range(repeat_x):
			## Skip entrance and exit tiles
			#if y == entranceY and x == entranceX:
				#continue
			#if y == exitY and x == exitX:
				#continue
#
			## Border tiles only
			#if y == 0 or y == repeat_y - 1 or x == 0 or x == repeat_x - 1:
				#var tile = floor_tile_scene.instantiate()
				#tile.position = Vector2(x * tile_size.x + offset, y * tile_size.y + offset)
				#add_child(tile)
