@tool
@icon("res://assert/05/GUI/dialogue_system/icons/chat_bubble.svg")
extends Node
class_name DialogueItem

@export var npc_info : NPCResource

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	check_npc_data()
	pass

func check_npc_data() -> void:
	if npc_info == null:
		var p = self
		var _checking : bool = true
		while _checking:
			p = p.get_parent()
			if p:
				if p is NPC and p.npc_resource:
					npc_info = p.npc_resource
					_checking = false
			else:
				_checking = false
	pass
