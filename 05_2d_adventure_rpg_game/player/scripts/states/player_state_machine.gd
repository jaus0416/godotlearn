extends Node
class_name PlayerStateMachine

var states : Array[PlayerState]
var prev_state : PlayerState
var curr_state : PlayerState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func initialize(_player : Player) -> void:
	states = []
	for child in get_children():
		if child is PlayerState:
			states.append(child)
	
	if states.size() == 0:
		return 
		
	for s in states:
		s.player = _player
		s.state_machine = self
		s.init()
	
	change_state(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	#print("init player state machine: %s" % str(states))
	pass

func change_state(new_state: PlayerState) -> void:
	if new_state == null || new_state == curr_state:
		return
		
	if curr_state:
		curr_state.exit()
	prev_state = curr_state
	curr_state = new_state
	curr_state.enter()
	pass

func _process(delta: float) -> void:
	change_state(curr_state.process(delta))
	pass

func _physics_process(delta: float) -> void:
	change_state(curr_state.physics_process(delta))
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	change_state(curr_state.handle_input(event))
	pass
