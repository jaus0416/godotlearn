@tool
@icon("res://assert/05/GUI/dialogue_system/icons/text_bubble.svg")
extends DialogueItem
class_name DialogueText

@export_multiline var text : String = "Placeholder Text" : set = _set_text

func _set_editor_display() -> void:
	example_dialogue.set_dialogue_text(self)
	example_dialogue.content.visible_characters = -1
	example_dialogue.choice_options.visible = false
	pass

func _set_text(value : String)  -> void:
	text = value
	if Engine.is_editor_hint():
		if example_dialogue != null:
			_set_editor_display()
	pass
