extends Node

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

var current_save : Dictionary = {
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = []
}

func save_game() -> void:
	# update data
	update_player_data()
	update_scene_path()
	update_item_data()
	
	# write file
	var file := FileAccess.open(SAVE_PATH + "save.sav", FileAccess.WRITE)
	# json 版本
	var save_json = JSON.stringify(current_save)
	file.store_line(save_json)
	
	# emit signal
	game_saved.emit()
	pass
	
func get_save_file() -> FileAccess:
	return FileAccess.open(SAVE_PATH + "save.sav", FileAccess.READ)
	
func load_game() -> void:
	# read file
	var file := get_save_file()
	if file == null:
		return
	var json := JSON.new()
	json.parse(file.get_line())
	var save_dict : Dictionary = json.get_data() as Dictionary

	current_save = save_dict
	
	# load scene
	LevelManager.load_new_level(current_save.scene_path, "", Vector2.ZERO)
	await LevelManager.level_load_started
	
	# load player
	PlayerManager.set_player_position(Vector2(current_save.player.pos_x, current_save.player.pos_y))
	PlayerManager.set_health(current_save.player.hp, current_save.player.max_hp)
	
	# load inventory
	PlayerManager.INVENTORY_DATA.parse_save_data(current_save.items)
	
	# emit signal
	await LevelManager.level_loaded
	game_loaded.emit() 
	pass

func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.hp = p.hp
	current_save.player.max_hp = p.max_hp
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y
	pass
	
func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p
	pass
	
func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
	pass

func add_persistant_value(value : String) -> void:
	if !check_persistant_value(value):
		current_save.persistence.append(value)
	pass

func check_persistant_value(value : String) -> bool:
	var p = current_save.persistence as Array
	return p.has(value)
