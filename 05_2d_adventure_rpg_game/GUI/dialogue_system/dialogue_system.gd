@tool
@icon("res://assert/05/GUI/dialogue_system/icons/star_bubble.svg")
extends CanvasLayer
class_name DialogueSystemNode

signal finished 
signal letter_added(letter : String)

var is_active : bool = false
var dialogue_items : Array[DialogueItem]
var dialogue_item_index : int = 0
var text_in_progress : bool = false
var text_speed : float = 0.02
var text_length : int = 0
var plain_text : String

@onready var dialogue_ui: Control = $DialogueUI
@onready var content: RichTextLabel = $DialogueUI/PanelContainer/RichTextLabel
@onready var portrait_sprite: DialoguePortrait = $DialogueUI/PortraitSprite
@onready var name_label: Label = $DialogueUI/NameLabel
@onready var dialogue_progress_indicator: PanelContainer = $DialogueUI/DialogueProgressIndicator
@onready var dialogue_progress_indicator_label: Label = $DialogueUI/DialogueProgressIndicator/Label
@onready var timer: Timer = $DialogueUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogueUI/AudioStreamPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child(self)
			return
		return
	timer.timeout.connect(_on_timer_timeout)
	hide_dialog()
	pass

func _unhandled_input(event: InputEvent) -> void:
	if !is_active:
		return
	if (
		event.is_action_pressed("interact")
		or event.is_action_pressed("attack")
		or event.is_action_pressed("ui_accept")
	):
		#如果对话展示中，加速
		if text_in_progress:
			content.visible_characters = text_length
			_on_timer_timeout()
			return
		
		dialogue_item_index += 1
		if dialogue_item_index < dialogue_items.size():
			start_dialogue()
		else:
			hide_dialog()
	pass

# 显示对话框
func show_dialog(_items : Array[DialogueItem]) -> void:
	is_active = true
	dialogue_ui.visible = true
	dialogue_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialogue_items = _items
	dialogue_item_index = 0
	get_tree().paused = true
	await get_tree().process_frame
	# 展示对话框内容
	start_dialogue()
	pass

func hide_dialog() -> void:
	is_active = false
	dialogue_ui.visible = false
	dialogue_ui.process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
	pass

func start_dialogue() -> void:
	show_dialogue_button_indicator(false)
	var _d = dialogue_items[dialogue_item_index] as DialogueItem
	set_dialogue_data(_d)
	
	#字体动画效果
	content.visible_characters = 0
	text_length = content.get_total_character_count()
	plain_text = content.get_parsed_text()
	text_in_progress = true
	start_timer()
	pass

func start_timer() -> void:
	timer.wait_time = text_speed
	
	timer.start()
	pass

func _on_timer_timeout() -> void:
	content.visible_characters += 1
	if content.visible_characters <= text_length:
		letter_added.emit(plain_text[content.visible_characters - 1])
		start_timer()
	else:
		show_dialogue_button_indicator(true)
		text_in_progress = false
	pass

func set_dialogue_data(_d : DialogueItem) -> void:
	if _d is DialogueText:
		content.text = _d.text
	
	name_label.text = _d.npc_info.npc_name
	portrait_sprite.texture = _d.npc_info.portrait
	portrait_sprite.audio_pitch_base = _d.npc_info.dialogue_audio_pitch
	pass

func show_dialogue_button_indicator(_is_visiable : bool) -> void:
	dialogue_progress_indicator.visible = _is_visiable
	if dialogue_item_index + 1 < dialogue_items.size():
		dialogue_progress_indicator_label.text = "下一个"
	else:
		dialogue_progress_indicator_label.text = "再见"
	pass
