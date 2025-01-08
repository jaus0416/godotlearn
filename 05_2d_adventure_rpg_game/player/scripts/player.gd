extends CharacterBody2D
class_name Player

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

signal DirectionChanged(new_direction : Vector2)

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine

func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	pass

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass
 
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	# 改变玩家朝向
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# 全局通知玩家朝向变动
	DirectionChanged.emit(new_direction)
	return true

func update_animation(state : String) -> void:
	var next_animation = state + "_" + anim_diretion()
	#print("play animation: %s" % next_animation)
	animation_player.play(next_animation)
	pass
	
func anim_diretion() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
