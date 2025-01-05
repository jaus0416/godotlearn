extends Area2D

@export var speed = 200 # How fast the player will move (pixels/sec).
var screen_size = Vector2.ZERO # Size of the game window.

func set_screen_size(_screen_size: Vector2) -> void:
	screen_size = _screen_size
	$StateMachine/MobIdle.position_range = screen_size
	$StateMachine/MobFollow.position_range = screen_size
