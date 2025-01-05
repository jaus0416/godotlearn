extends State
class_name MobFollow

@export var enemy : Area2D
@export var speed = 200
var player : Area2D
var position_range : Vector2

func enter():
	player = get_tree().get_first_node_in_group("Player")

func physics_update(_delta: float):
	var deriction = player.position - enemy.position
	if deriction.length() > 25:
		var velocity = deriction.normalized() * speed
		if enemy.find_child("AnimatedSprite2D"):
			var animated_node = enemy.find_child("AnimatedSprite2D")
			if velocity.length() > 0:
				animated_node.play()
				animated_node.flip_h = velocity.x < 0
			else:
				animated_node.stop()
		enemy.position += velocity * _delta
		enemy.position = enemy.position.clamp(Vector2.ZERO, position_range)

	if deriction.length() > 300:
		transitioned.emit(self, "MobIdle")
