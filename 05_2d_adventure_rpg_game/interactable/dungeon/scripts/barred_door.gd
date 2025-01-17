extends Node2D
class_name BarredDoor

var is_open : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var persistant_is_open: PersistantDataHandler = $PersistantIsOpen

func _ready() -> void:
	LevelManager.level_leaved.connect(save_open_status)
	persistant_is_open.data_loaded.connect(load_open_status)
	load_open_status()
	pass
	
func save_open_status() -> void:
	if is_open:
		persistant_is_open.set_value()
	pass

func load_open_status() -> void:
	if persistant_is_open.value:
		animation_player.play("opened")
	pass
	
func open_door() -> void:
	if !is_open:
		is_open = true
		animation_player.play("open_door")
	pass

func close_door() -> void:
	if is_open:
		is_open = false
		animation_player.play("close_door")
	pass
