extends Node
class_name PlayerState

static var player : Player

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func process(_delta: float) -> PlayerState:
	return null
	
func physics_process(_delta: float) -> PlayerState:
	return null

func handle_input(_event: InputEvent) -> PlayerState:
	return null
