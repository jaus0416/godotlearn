extends PlayerState
class_name PlayerStateWalk

@export var move_speed : float = 100.0

@onready var idle : PlayerState = $"../Idle"
@onready var attack : PlayerState = $"../Attack"

func enter() -> void:
	player.update_animation("walk")
	pass
	
func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	if player.direction == Vector2.ZERO:
		return idle
	player.velocity = player.direction * move_speed
	
	if player.set_direction():
		player.update_animation("walk")
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	if _event.is_action_pressed("attack"):
		return attack
	if _event.is_action_pressed("interact"):
		PlayerManager.interact_pressed.emit()
	return null
