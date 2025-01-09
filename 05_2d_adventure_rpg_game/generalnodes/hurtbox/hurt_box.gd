extends Area2D
class_name HurtBox

@export var damage : int = 1 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(handle_area_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func handle_area_entered(area : Area2D) -> void:
	if area is HitBox:
		area.take_damage(self)
	pass
