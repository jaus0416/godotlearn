extends Node
class_name PersistantDataHandler

signal data_loaded

var value : bool = false

func _ready() -> void:
	load_value()
	pass
	
func set_value() -> void:
	SaveManager.add_persistant_value(_get_name())
	pass

func load_value() -> void:
	value = SaveManager.check_persistant_value(_get_name())
	data_loaded.emit()
	pass

func _get_name() -> String:
	# 'res://05_2d_adventure_rpg_game/levels/area_01/area_01.tscn/TreasureChest/PersistantIsOpen'
	return get_tree().current_scene.scene_file_path + "/" + get_parent().name + "/" + name
