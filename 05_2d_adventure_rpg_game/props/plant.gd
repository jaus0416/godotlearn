extends Node2D
class_name Plant

func _ready() -> void:
	$HitBox.damaged.connect(take_damage)
	pass

func take_damage(_hurt_box : HurtBox) -> void:
	queue_free()
	pass
