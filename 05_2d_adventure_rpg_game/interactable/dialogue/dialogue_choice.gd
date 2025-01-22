@tool
@icon("res://assert/05/GUI/dialogue_system/icons/question_bubble.svg")
extends DialogueItem
class_name DialogueChoice

var dialog_branches : Array[DialogueBranch]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	for c in get_children():
		if c is DialogueBranch:
			dialog_branches.append(c)
	pass

# 给出编辑器提示
func _get_configuration_warnings() -> PackedStringArray:
	if !_check_for_dialog_branches():
		return ["Requires at least 2 DialogueBranches Node"]
	else:
		return []

func _check_for_dialog_branches() -> bool:
	var _count : int = 0
	for c in get_children():
		if c is DialogueBranch:
			_count += 1
	
	if _count > 1:
		return true
	return false
	
