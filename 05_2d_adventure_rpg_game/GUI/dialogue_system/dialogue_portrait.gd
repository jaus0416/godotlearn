@tool
extends Sprite2D
class_name DialoguePortrait

var blink : bool = false : set = _set_blink
var open_mouth : bool = false : set = _set_open_mouth
var mouth_open_frames : int = 0
var audio_pitch_base : float = 1.0

@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	DialogueSystem.letter_added.connect(check_mouth_open)
	blinker()
	pass

func check_mouth_open(letter : String) -> void:
	# 随机张嘴
	if randi_range(0, 10) < 3:
		# 元音张嘴
		#if 'aeiouy123456789'.contains(letter):
			#open_mouth = true
			#mouth_open_frames += 3
			#audio_stream_player.play()
		#elif '.,!?'.contains(letter):
			#mouth_open_frames =0
		open_mouth = true
		mouth_open_frames += 3
		print("audio_pitch_base: " + str(audio_pitch_base))
		audio_stream_player.pitch_scale = randf_range(audio_pitch_base - 0.2, audio_pitch_base + 0.2)
		audio_stream_player.play()
	if '.,!?。，！？'.contains(letter):
		mouth_open_frames = 0
	#print("letter: " + letter + ", mouth_open_frames: " + str(mouth_open_frames))
	if mouth_open_frames > 0:
		mouth_open_frames -= 1
	
	if mouth_open_frames == 0:
		open_mouth = false
	pass

func blinker() -> void:
	if !blink:
		await get_tree().create_timer(randf_range(0.1, 3)).timeout
	else:
		await get_tree().create_timer(0.15).timeout
	blink = not blink
	blinker()
	pass

func _set_blink(_value : bool) -> void:
	if blink != _value:
		blink = _value
		update_portrait()
	pass

func _set_open_mouth(_value : bool) -> void:
	if open_mouth != _value:
		open_mouth = _value
		update_portrait()
	pass

func update_portrait() -> void:
	if open_mouth:
		frame = 2
	else:
		frame = 0
	
	if blink:
		frame += 1
	pass
