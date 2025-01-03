extends Sprite2D

# 全局属性
var speed = 400
var angular_speed = PI
var target_pos := position
var speed_x = 100
var speed_y = 100

# 1. >>>>>> 小机器人自动转圈
#func _process(delta):
	#rotation += angular_speed * delta
	#var velocity = Vector2.UP.rotated(rotation) * speed
	#position += velocity * delta

# 2. >>>>>> wasd 控制移动
#func _unhandled_key_input(event: InputEvent):
	#print("enter key: " + event.as_text())
	#if event.is_released():
		#if event.keycode == KEY_ESCAPE:
			#get_tree().quit()
		#if event.keycode == KEY_D:
			#position += Vector2(100, 0)
		#elif event.keycode == KEY_W:
			#position += Vector2(0, -100)
		#elif event.keycode == KEY_A:
			#position += Vector2(-100, 0)
		#elif event.keycode == KEY_S:
			#position += Vector2(0, 100)

# 3. >>>>>> 获取鼠标点按位置，并自动移动
#func _unhandled_input(event: InputEvent):
	#if event is InputEventMouseMotion:
		#return
	#print("enter key: " + event.as_text())
	#if event.is_released():
		#if event is InputEventMouseButton:
			#if event.button_index == MOUSE_BUTTON_LEFT:
				#print("鼠标左键被按下了")
				#refresh_target_pos()
			#elif event.button_index == MOUSE_BUTTON_RIGHT:
				#print("鼠标右键被按下了")
#
#func refresh_target_pos():
	#target_pos = get_global_mouse_position()
#
#func caculate_move_postion(curr_pos: Vector2, target_pos: Vector2, _speed_x: float, _speed_y: float):
	#var pos_diff = target_pos - curr_pos
	## 计算方向
	#var direct = caculate_direct(pos_diff)
	#var move_pos = Vector2(_speed_x, _speed_y).min(pos_diff.abs())
	#move_pos *= direct
	#return move_pos
#
#func caculate_direct(pos: Vector2):
	#var res = Vector2(1, 1)
	#if pos.x < 0:
		#res.x = -1
	#if pos.y < 0:
		#res.y = -1
	#return res
#
#func _process(delta):
	#if position != target_pos:
		#var move_pos = caculate_move_postion(position, target_pos, speed_x * delta, speed_y * delta)
		#position += move_pos

# 4. >>>>>> wasd / 上下左右 / 鼠标左键 控制方向并移动
#func _process(delta):
	## 记录一个快照
	#var mouse_position = get_global_mouse_position()
	#var direction = caculate_direction(mouse_position)
	#rotation += angular_speed * direction * delta
	#var velocity = caculate_velocity(mouse_position, delta)
	#position += velocity
#
## 计算要改变的方向
#func caculate_direction(mouse_position):
	## 方向键控制
	## 判断是否向左
	#if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		#return -1
	## 判断是否向右
	#if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		#return 1
	## 判断鼠标控制
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#return caculate_mouse_direction(mouse_position)
	#return 0
#
## 计算点按鼠标的情况下要改变的方向
#func caculate_mouse_direction(mouse_position):
	## 将鼠标点击位置转换到以物体为中心的坐标系下
	#var relative_mouse_position = mouse_position - position
	## 对相对位置向量根据物体旋转角度进行旋转，使其与物体朝向对齐
	#var rotated_relative_mouse_position = rotate_vector(relative_mouse_position, -rotation)
	#if rotated_relative_mouse_position.x < 0:
		#return -1
	#elif rotated_relative_mouse_position.x > 0:
		#return 1
	#return 0
#
## 对向量根据给定角度进行旋转操作（这里采用二维旋转矩阵的原理实现）
#func rotate_vector(vector, angle_radians):
	#var cos_angle = cos(angle_radians)
	#var sin_angle = sin(angle_radians)
	#return Vector2(
		#vector.x * cos_angle - vector.y * sin_angle,
		#vector.x * sin_angle + vector.y * cos_angle
	#)
#
## 计算移动速度
#func caculate_velocity(mouse_position, delta):
	## 方向键控制
	#if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		#return Vector2.UP.rotated(rotation) * speed * delta
	#if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		#return Vector2.DOWN.rotated(rotation) * speed * delta
	## 鼠标控制
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		#return caculate_mouse_velocity(mouse_position, delta)
	#return Vector2.ZERO
#
## 计算鼠标移动的位置
#func caculate_mouse_velocity(mouse_position, delta):
	#if mouse_position - position != Vector2.ZERO:
		#var velocity = Vector2.UP.rotated(rotation) * speed * delta
		#print("user position: " + str(position))
		#print("mouse position: " + str(mouse_position))
		#print("mouse velocity: " + str(velocity))
		## 如果超过了鼠标位置，最远移动到鼠标位置
		#velocity = handle_mouse_move_over_target(position, velocity, mouse_position)
		#print("fixed velocity: " + str(velocity))
		#return velocity
	#return Vector2.ZERO
#
##判断鼠标位移是否超过了目标位置
#func handle_mouse_move_over_target(curr_position: Vector2, velocity: Vector2, mouse_position: Vector2):
	#var need_move = mouse_position - curr_position
	## 判断x轴
	#if need_move.abs().x < velocity.abs().x:
		#velocity.x = need_move.x
	#if need_move.abs().y < velocity.abs().y:
		#velocity.y = need_move.y
	#return velocity
	#
## 获取向量当前方向
#func get_vector_direction(vec: Vector2):
	#var res = Vector2(1, 1)
	#if vec.x < 0:
		#res.x = -1
	#if vec.y < 0:
		#res.y = -1
	#return res
