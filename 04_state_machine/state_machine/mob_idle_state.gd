extends State
class_name MobIdle

@export var enemy = Area2D
@export var move_speed = 100

var move_deriction : Vector2
var wander_time : float
var position_range : Vector2
var player : Area2D

func randomize_wander():
	move_deriction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func enter():
	randomize_wander()
	player = get_tree().get_first_node_in_group("Player")

func update(delta: float):
	if wander_time > 0:
		wander_time -= delta
	else:
		randomize_wander()
	
func physics_update(_delta: float):
	if enemy:
		var velocity = move_deriction * move_speed
		if enemy is Node2D and enemy.find_child("AnimatedSprite2D"):
			var animated_node = enemy.find_child("AnimatedSprite2D")
			if velocity.length() > 0:
				animated_node.play()
				animated_node.flip_h = velocity.x < 0
			else:
				animated_node.stop()
		enemy.position += velocity * _delta
		enemy.position = enemy.position.clamp(Vector2.ZERO, position_range)
		# 触墙反弹
		if enemy.position.x == 0 or enemy.position.y == 0 or enemy.position.x == position_range.x or enemy.position.y == position_range.y:
			randomize_wander()
		
		var deriction = player.position - enemy.position
		if deriction.length() < 280:
			transitioned.emit(self, "MobFollow")
