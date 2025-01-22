@tool
@icon("res://assert/05/GUI/dialogue_system/icons/chat_bubbles.svg")
extends Area2D
class_name DialogueIntercation

signal player_interacted
signal finished

@export var enabled : bool = true

var dialogue_items : Array[DialogueItem]

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_entered.connect(_on_area_enter)
	area_exited.connect(_on_area_exit)
	for c in get_children():
		if c is DialogueItem:
			dialogue_items.append(c)
	pass

func _on_area_enter(_a : Area2D) -> void:
	if !enabled || dialogue_items.size() == 0:
		return
	animation_player.play("show")
	PlayerManager.interact_pressed.connect(player_interact)
	pass

func _on_area_exit(_a : Area2D) -> void:
	animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect(player_interact)
	pass

func player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	DialogueSystem.show_dialog(dialogue_items)
	if !DialogueSystem.finished.is_connected(_on_dialogue_finished):
		DialogueSystem.finished.connect(_on_dialogue_finished)
	pass

func _on_dialogue_finished() -> void:
	DialogueSystem.finished.disconnect(_on_dialogue_finished)
	finished.emit()
	pass
	
# 给出编辑器提示
func _get_configuration_warnings() -> PackedStringArray:
	if !_check_for_dialog_item():
		return ["Requires at least one DialogueItem Node"]
	else:
		return []

func _check_for_dialog_item() -> bool:
	for c in get_children():
		if c is DialogueItem:
			return true
	
	return false
