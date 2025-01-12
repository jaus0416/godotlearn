extends CanvasLayer

signal shown
signal hidden

@onready var button_save : Button = $Control/HBoxContainer/ButtonSave
@onready var button_load : Button = $Control/HBoxContainer/ButtonLoad
@onready var item_description : Label = $Control/ItemDescription
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

var is_paused : bool = false

func _ready() -> void:
	hide_pause_menu()
	button_save.pressed.connect(_on_save_pressed)
	button_load.pressed.connect(_on_load_pressed)
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if !is_paused:
			show_pause_menu()
			pass
		else:
			hide_pause_menu()
			pass
	get_viewport().set_input_as_handled()
	pass

func show_pause_menu() -> void:
	#PlayerHud.visible = false
	get_tree().paused = true
	visible = true
	is_paused = true
	button_save.grab_focus()
	shown.emit()
	pass

func hide_pause_menu() -> void:
	#PlayerHud.visible = true
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()
	pass

func _on_save_pressed() -> void:
	if !is_paused:
		return 
	SaveManager.save_game()
	hide_pause_menu()
	pass
	
func _on_load_pressed() -> void:
	if !is_paused:
		return 
	SaveManager.load_game()
	
	await  LevelManager.level_load_started
	
	hide_pause_menu()
	pass

func update_item_description(new_text : String) -> void:
	item_description.text = new_text
	pass

func play_audio(audio : AudioStream) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()
	pass
