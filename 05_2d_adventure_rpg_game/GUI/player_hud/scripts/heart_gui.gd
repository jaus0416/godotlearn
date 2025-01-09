extends Control
class_name HeartGUI

@onready var sprite = $Sprite2D

# 血量帧 0 满 1 半 2 空
var value : int = 2 : 
	set(_value) :
		value = _value
		update_sprite()
		pass

func update_sprite() -> void:
	sprite.frame = value
	pass
