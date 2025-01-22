extends Resource
class_name NPCResource

@export var npc_name : String = "default_name"
@export var sprite : Texture
@export var portrait : Texture
@export_range(0.5, 1.0, 0.02) var dialogue_audio_pitch : float = 1.0
