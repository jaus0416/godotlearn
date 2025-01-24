extends Node2D

const START_LEVEL : String = "res://05_2d_adventure_rpg_game/levels/area_01/area_01.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_pressed_audio : AudioStream

@onready var new_game_btn: Button = $CanvasLayer/Control/NewGame
@onready var load_game_btn: Button = $CanvasLayer/Control/LoadGame
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	
	PlayerHud.visible = false
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	if SaveManager.get_save_file() == null:
		load_game_btn.disabled = true
	
	$CanvasLayer/SplashScene.finished.connect(setup_title_screen)
	
	LevelManager.level_load_started.connect(exit_title_screen)
	pass

func setup_title_screen() -> void:
	AudioManager.play_music(music)
	
	new_game_btn.pressed.connect(start_game)
	load_game_btn.pressed.connect(load_game)
	new_game_btn.grab_focus()
	
	new_game_btn.focus_entered.connect(play_audio.bind(button_focus_audio))
	load_game_btn.focus_entered.connect(play_audio.bind(button_focus_audio))
	pass

func start_game() -> void:
	play_audio(button_pressed_audio)
	LevelManager.load_new_level(START_LEVEL, "", Vector2.ZERO)
	pass

func load_game() -> void:
	play_audio(button_pressed_audio)
	SaveManager.load_game()
	pass

func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PlayerHud.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass

func play_audio(_a : AudioStream) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
	pass
