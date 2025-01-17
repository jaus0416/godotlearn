extends Node2D
class_name LockedDoor

var is_open : bool = false

# what type of item can open
@export var key_item :ItemData 
@export var locked_audio : AudioStream
@export var open_audio : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var persistant_is_open: PersistantDataHandler = $PersistantDataHandler
@onready var interact_area_2d: Area2D = $InteractArea2D

func _ready() -> void:
	interact_area_2d.area_entered.connect(_on_area_enter)
	interact_area_2d.area_exited.connect(_on_area_exit)
	persistant_is_open.data_loaded.connect(set_state)
	set_state()
	pass
	
func open_door() -> void:
	if !key_item:
		return
	var door_unlocked = PlayerManager.INVENTORY_DATA.use_item(key_item)
	if door_unlocked:
		animation_player.play("open_door")
		audio_stream_player_2d.stream = open_audio
		persistant_is_open.set_value()
	else:
		audio_stream_player_2d.stream = locked_audio
	audio_stream_player_2d.play()
	pass

func close_door() -> void:
	animation_player.play("close_door")
	pass

func set_state() -> void:
	is_open = persistant_is_open.value
	if is_open:
		animation_player.play("opened")
	else:
		animation_player.play("closed")
	pass
	
func _on_area_enter(_a : Area2D) -> void:
	PlayerManager.interact_pressed.connect(open_door)
	pass

func _on_area_exit(_a : Area2D) -> void:
	PlayerManager.interact_pressed.disconnect(open_door)
	pass
