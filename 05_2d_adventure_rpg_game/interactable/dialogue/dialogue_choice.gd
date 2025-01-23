@tool
@icon("res://assert/05/GUI/dialogue_system/icons/question_bubble.svg")
extends DialogueItem
class_name DialogueChoice

var dialog_branches : Array[DialogueBranch]

func _ready() -> void:
	super()
	for c in get_children():
		if c is DialogueBranch:
			dialog_branches.append(c)
	pass

func _set_editor_display() -> void:
	if dialog_branches.size() < 2:
		return
	example_dialogue.set_dialogue_choice(self)
	
	set_related_edit()
	pass
	
func set_related_edit() -> void:
	var _p = get_parent()
	var _i = self.get_index()
	var _t = _p.get_child(_i - 1)
	if _t != null and _t is DialogueText:
		example_dialogue.set_dialogue_text(_t)
		example_dialogue.content.visible_characters = -1
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
	
