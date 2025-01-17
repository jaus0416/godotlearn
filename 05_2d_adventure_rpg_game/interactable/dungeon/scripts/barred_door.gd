extends Node2D
class_name BarredDoor

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	pass
	
func open_door() -> void:
	animation_player.play("open_door")
	pass

func close_door() -> void:
	animation_player.play("close_door")
	pass
