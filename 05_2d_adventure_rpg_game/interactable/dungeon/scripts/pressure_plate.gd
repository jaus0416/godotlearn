extends Node2D
class_name PressurePlate

signal activated
signal deactivated

var bodies : int = 0
var is_active : bool = false
var off_rect : Rect2

@onready var area_2d: Area2D = $Area2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_active : AudioStream = preload("res://assert/05/interactable/dungeon/lever-01.wav")
@onready var audio_deactive : AudioStream = preload("res://assert/05/interactable/dungeon/lever-02.wav")
@onready var persistant_pressed: PersistantDataHandler = $PersistantPressed

func _ready() -> void:
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	off_rect = sprite_2d.region_rect
	
	# 持久化开启状态
	persistant_pressed.data_loaded.connect(load_pressed)
	load_pressed()
	LevelManager.level_leaved.connect(save_pressed)
	pass

func load_pressed():
	is_active = persistant_pressed.value
	if persistant_pressed.value:
		sprite_2d.region_rect.position.x = off_rect.position.x - 32
	pass

func save_pressed():
	if is_active:
		persistant_pressed.set_value()
	pass

func _on_body_entered(_b : Node2D) -> void:
	bodies += 1
	check_is_actived()
	pass

func _on_body_exited(_b : Node2D) -> void:
	bodies -= 1
	check_is_actived()
	pass

func check_is_actived() -> void:
	if bodies > 0 and !is_active:
		is_active = true
		sprite_2d.region_rect.position.x = off_rect.position.x - 32
		play_audio(audio_active)
		activated.emit()
	elif bodies <= 0 and is_active and !persistant_pressed.value:
		is_active = false
		sprite_2d.region_rect.position.x = off_rect.position.x
		play_audio(audio_deactive)
		deactivated.emit()
	pass

func play_audio(audio_stream : AudioStream) -> void:
	audio_stream_player_2d.stream = audio_stream
	audio_stream_player_2d.play()
