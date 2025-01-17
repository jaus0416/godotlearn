extends Node2D
class_name Boomerang

enum State {INACTIVE, THROW, RETURN}
var player : Player
var direction : Vector2
var speed : float = 0
var state 

@export var acceleration : float = 500.0
@export var max_speed : float = 400.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	visible = false
	state = State.INACTIVE
	player = PlayerManager.player
	pass

func _physics_process(_delta: float) -> void:
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
			queue_free()
		pass
	pass

func throw(throw_direction : Vector2) -> void:
	direction = throw_direction
	speed = max_speed
	state = State.THROW
	animation_player.play("boomerang")
	visible = true
	pass
