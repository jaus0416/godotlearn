extends Node2D
class_name Plant

func _ready() -> void:
	$HitBox.Damaged.connect(take_damage)
	pass

func take_damage(_damage : int) -> void:
	queue_free()
	pass
