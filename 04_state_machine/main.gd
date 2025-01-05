extends Node

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = $Player.get_viewport_rect().size
	$Player.screen_size = screen_size
	$Mob.set_screen_size(screen_size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
