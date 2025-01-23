@tool
@icon("res://assert/05/GUI/dialogue_system/icons/answer_bubble.svg")
extends DialogueItem
class_name DialogueBranch

@export var text : String = "ok ..." : set = _set_text

var dialogue_items : Array[DialogueItem]

func _ready() -> void:
	super()
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogueItem:
			dialogue_items.append(c)
	pass

func _set_editor_display() -> void:
	var _p = get_parent()
	if _p is DialogueChoice:
		set_related_edit()
		if _p.dialog_branches.size() < 2:
			return
		example_dialogue.set_dialogue_choice(_p)
	pass

func _set_text(_value : String) -> void:
	text = _value
	if Engine.is_editor_hint():
		if example_dialogue != null:
			_set_editor_display()
	pass

func set_related_edit() -> void:
	var _p = get_parent().get_parent()
	var _i = get_parent().get_index()
	var _t = _p.get_child(_i - 1)
	if _t != null and _t is DialogueText:
		example_dialogue.set_dialogue_text(_t)
		example_dialogue.content.visible_characters = -1
	pass
