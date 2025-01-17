extends Node2D
class_name EnemyCounter

signal enemies_defeated

func _ready() -> void:
	child_exiting_tree.connect(_on_enemy_destoryed)
	pass

func _on_enemy_destoryed(e : Node2D) -> void:
	if e is Enemy:
		if enemy_count() <= 1:
			enemies_defeated.emit()
			#print("Enemy clear")
	pass

func enemy_count() -> int:
	var _count : int = 0
	for c in get_children():
		if c is Enemy:
			_count += 1
	return _count
