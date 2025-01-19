extends Node2D
class_name Level

@export var music : AudioStream

func _ready() -> void:
	self.y_sort_enabled = true
	PlayerManager.set_as_parent(self)
	LevelManager.level_load_started.connect(_free_level)
	AudioManager.play_music(music)
	pass

func _free_level() -> void:
	# 防止free player
	PlayerManager.unparent_player(self)
	queue_free()
	pass
