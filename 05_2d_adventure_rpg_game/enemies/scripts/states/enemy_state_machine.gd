extends Node
class_name EnemyStateMachine

var states : Array[EnemyState]
var prev_state : EnemyState
var curr_state : EnemyState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

func initialize(_enemy : Enemy) -> void:
	states = []
	for child in get_children():
		if child is EnemyState:
			states.append(child)
	
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
	#print("init enemy[" + _enemy.name + "] state machine: " + str(states))
	pass
	
func _process(_delta: float) -> void:
	change_state(curr_state.process(_delta))
	pass

func _physics_process(_delta: float) -> void:
	change_state(curr_state.physics_process(_delta))
	pass

func change_state(new_state : EnemyState) -> void:
	if new_state == null || new_state == curr_state:
		return 
	
	if curr_state:
		curr_state.exit()
	
	prev_state = curr_state
	curr_state = new_state
	curr_state.enter()
	pass
