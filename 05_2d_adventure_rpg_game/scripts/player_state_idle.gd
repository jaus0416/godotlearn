extends PlayerState
class_name PlayerStateIdle

@onready var walk : PlayerState = $"../Walk"

func enter() -> void:
	player.update_animation("idle")
	pass
	
func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	if player.deriction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	return null
