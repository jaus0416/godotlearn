extends Node

var curr_tilemap_bounds : Array[Vector2]

signal TilemapBoundsChanged(bounds : Array[Vector2])

func change_tilemap_bounds(bounds : Array[Vector2]) -> void:
	curr_tilemap_bounds = bounds
	TilemapBoundsChanged.emit(bounds)
	pass
