extends Area2D

# 全局变量
# 速度
# @export: 允许在侧边栏设置变量的值
@export var speed = 400
# 屏幕大小
var screen_size

# 信号
# 碰撞
signal hit

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# 游戏开始时隐藏玩家
	hide()

# 开始游戏
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# 1. 计算速度
	var velocity = caculate_vlocity(delta)
	# 2. 移动
	do_move(velocity)
	
# 计算速度
func caculate_vlocity(delta: float) -> Vector2:
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	return velocity * delta

# 移动
func do_move(velocity: Vector2):
	# 控制移动
	position += velocity
	position = position.clamp(Vector2.ZERO, screen_size)
	# 控制动画
	play_move_animation(velocity)
	
# 播放移动动画
func play_move_animation(velocity: Vector2):
	# 播放移动动画
	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	# 控制上下左右翻转
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "horizontal"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "vertical"
		$AnimatedSprite2D.flip_v = velocity.y > 0

# 碰撞检测
func _on_body_entered(body: Node2D) -> void:
	hide() # Player disappears after being hit.
	hit.emit()
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)
