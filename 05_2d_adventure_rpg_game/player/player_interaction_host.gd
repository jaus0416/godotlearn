extends Node2D
class_name PlayerIntercationHost

@onready var player : Player = $".."

func _ready() -> void:
	player.DirectionChanged.connect(update_deriction)
	pass


func update_deriction(new_direction : Vector2) -> void:
	#match new_direction:
		#Vector2.DOWN:
			#rotation_degrees = 0
		#Vector2.UP:
			#rotation_degrees = 180
		#Vector2.LEFT:
			#rotation_degrees = 90
		#Vector2.RIGHT:
			#rotation_degrees = -90
		#_:
			#rotation_degrees = 0
	pass
