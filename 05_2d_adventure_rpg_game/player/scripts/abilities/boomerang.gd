extends Node2D
class_name Boomerang

enum State {INACTIVE, THROW, RETURN}
var player : Player
var direction : Vector2
var speed : float = 0
var state 

@export var acceleration : float = 500.0
@export var max_speed : float = 400.0
@export var catch_autio : AudioStream

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player
	pass

func _physics_process(_delta: float) -> void:
	# 处理基础状态
	if state == State.THROW:
		speed -= acceleration * _delta
		position += direction * speed * _delta
		if speed <= 0:
			state = State.RETURN
		pass
	elif state == State.RETURN:
		direction = global_position.direction_to(player.global_position)
		speed += acceleration * _delta
		position += direction * speed * _delta
		if global_position.distance_to(player.global_position) <= 10:
			PlayerManager.play_audio(catch_autio)
			queue_free()
		pass
		
	# 处理音频效果
	var speed_ratio = speed / max_speed
	audio_stream_player_2d.pitch_scale = speed_ratio * 0.75 + 0.75
	# 处理动画速度
	animation_player.speed_scale = 1 + (speed_ratio * 0.25) 
	pass

func throw(throw_direction : Vector2) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	animation_player.play("boomerang")
	PlayerManager.play_audio(catch_autio)
	visible = true
	pass
