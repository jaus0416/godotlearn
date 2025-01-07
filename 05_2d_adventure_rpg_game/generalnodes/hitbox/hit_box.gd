extends Area2D
class_name HitBox

signal Damaged(damage: int)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func take_damage(damage: int) -> void:
	print("take damage: ", damage)
	Damaged.emit(damage)
	pass
