@tool
extends Node2D
class_name ItemDropper

const PICKUP = preload("res://05_2d_adventure_rpg_game/items/item_pickup/item_pick_up.tscn")

@export var item_data : ItemData : set = _set_item_data

var has_dropped = false

@onready var sprite: Sprite2D = $Sprite2D
@onready var persistant_data_handler: PersistantDataHandler = $PersistantDataHandler
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_texture()
		return 
	sprite.visible = false
	
	persistant_data_handler.data_loaded.connect(_on_data_loaded)
	_on_data_loaded()
	pass

func drop_item() -> void:
	if has_dropped:
		return
	has_dropped = true
	var drop = PICKUP.instantiate() as ItemPickUp
	drop.item_data = item_data
	add_child(drop)
	drop.picked_up.connect(_on_drop_pickup)
	audio_stream_player.play()
	pass

func _on_drop_pickup() -> void:
	persistant_data_handler.set_value()
	pass

func _on_data_loaded() -> void:
	has_dropped = persistant_data_handler.value
	pass

func _set_item_data(value : ItemData) -> void:
	item_data = value
	_update_texture()
	pass
	
func _update_texture() -> void:
	if Engine.is_editor_hint():
		if item_data and sprite:
			sprite.texture = item_data.texture
	pass
