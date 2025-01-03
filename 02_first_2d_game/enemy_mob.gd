extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 三个敌人随机选一个播放
	var mob_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(mob_types[randi() % mob_types.size()])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 超出屏幕时删除自己
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
