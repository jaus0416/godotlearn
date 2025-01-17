extends TileMapLayer
class_name LevelTileMap

func _ready() -> void:
	LevelManager.change_tilemap_bounds(get_tilemap_bounds())
	pass

func get_tilemap_bounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	var tile_size : int = get_tile_set().tile_size.x
	bounds.append(
		Vector2(get_used_rect().position * tile_size)
	)
	bounds.append(
		Vector2(get_used_rect().end * tile_size)
	)
	return bounds
