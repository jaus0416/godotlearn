extends CharacterBody2D
class_name Player

var cardinal_deriction : Vector2 = Vector2.DOWN
var deriction : Vector2 = Vector2.ZERO
var move_speed : float = 100.0 
var state : String = "idle"

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	deriction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	deriction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if deriction.length() > 0:
		deriction = deriction.normalized()
	velocity = deriction * move_speed
	if set_state() || set_deriction():
		update_animation()

func _physics_process(delta: float) -> void:
	move_and_slide()
 
func set_deriction() -> bool:
	var new_deriction : Vector2 = cardinal_deriction
	if deriction == Vector2.ZERO:
		return false
	
	if deriction.y == 0:
		new_deriction = Vector2.LEFT if deriction.x < 0 else Vector2.RIGHT
	elif deriction.x == 0:
		new_deriction = Vector2.UP if deriction.y < 0 else Vector2.DOWN
	
	if new_deriction == cardinal_deriction:
		return false
	
	cardinal_deriction = new_deriction
	sprite.scale.x = -1 if cardinal_deriction == Vector2.LEFT else 1
	return true

func set_state() -> bool:
	var new_state : String = "idle" if deriction == Vector2.ZERO else "walk"
	if new_state == state:
		return false
	
	state = new_state
	return true

func update_animation() -> void:
	var next_animation = state + "_" + anim_derition()
	print("play animation: %s" % next_animation)
	animation_player.play(next_animation)
	pass
	
func anim_derition() -> String:
	if cardinal_deriction == Vector2.DOWN:
		return "down"
	elif cardinal_deriction == Vector2.UP:
		return "up"
	else:
		return "side"
