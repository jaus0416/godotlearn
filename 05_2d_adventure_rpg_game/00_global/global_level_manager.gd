extends Node

signal tilemap_bounds_changed(bounds : Array[Vector2])
signal level_load_started
signal level_loaded

var curr_tilemap_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()
	pass

# 检测地图边缘
func change_tilemap_bounds(bounds : Array[Vector2]) -> void:
	curr_tilemap_bounds = bounds
	tilemap_bounds_changed.emit(bounds)
	pass
	
# 地图切换
func load_new_level(
	level_path : String, 
	_target_transition : String,
	_position_offset : Vector2
) -> void:
	print("load new level: path: " + level_path + ", _target_transition" + _target_transition + ", position: " + str(_position_offset))
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file(level_path)
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false
	
	level_loaded.emit()
	pass
