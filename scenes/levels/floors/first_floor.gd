@tool
extends Node2D

@export var floor_tile_scene: PackedScene
@export var repeat_x: int = 5
@export var repeat_y: int = 5  # Adjust this as needed for height
@export var tile_size: Vector2 = Vector2(128, 128)  # Tile size set to 128x128

func _ready():
	for y in range(repeat_y):
		for x in range(repeat_x):
			# Skip the second tile on the top row for the player to drop in
			if y == 0 and x == 1:
				continue
			
			# Check if the tile is part of the border (top, bottom, left, or right)
			if y == 0 or y == repeat_y - 1 or x == 0 or x == repeat_x - 1:
				var tile = floor_tile_scene.instantiate()
				tile.position = Vector2(x * tile_size.x, y * tile_size.y)
				add_child(tile)
