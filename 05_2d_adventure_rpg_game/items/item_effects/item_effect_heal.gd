extends ItemEffect
class_name ItemEffectHeal

@export var heal_amount : int = 1
@export var audio : AudioStream 

func use() -> void:
	PlayerManager.player.update_hp(heal_amount)
	#play sound
	PauseMenu.play_audio(audio)
	pass
