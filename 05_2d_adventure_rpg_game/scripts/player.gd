extends CharacterBody2D
class_name Player

var move_speed : float = 100.0 

func _process(delta: float) -> void:
	var deriction : Vector2 = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		deriction.x += 1
	if Input.is_action_pressed("move_left"):
		deriction.x -= 1
	if Input.is_action_pressed("move_up"):
		deriction.y -= 1
	if Input.is_action_pressed("move_down"):
		deriction.y += 1
	
	if deriction.length() > 0:
		deriction = deriction.normalized()
	velocity = deriction * move_speed

func _physics_process(delta: float) -> void:
	move_and_slide()
 
