extends Node2D
class_name Level


func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	pass
