@tool
@icon("res://assert/05/GUI/dialogue_system/icons/answer_bubble.svg")
extends DialogueItem
class_name DialogueBranch

@export var text : String = "ok ..."

var dialogue_items : Array[DialogueItem]

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	for c in get_children():
		if c is DialogueItem:
			dialogue_items.append(c)
	pass
