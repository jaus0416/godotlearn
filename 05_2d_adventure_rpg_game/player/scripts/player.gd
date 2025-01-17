extends CharacterBody2D
class_name Player

signal direction_changed(new_direction : Vector2)
signal player_damaged(hurt_box : HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO

var invulnerable : bool = false
var max_hp : int = 6
var hp : int = 0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var effect_animation_player : AnimationPlayer = $EffectAnimationPlayer
@onready var hit_box : HitBox = $HitBox
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $PlayerStateMachine
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $Audio/AudioStreamPlayer2D


func _ready() -> void:
	# 全局玩家管理器
	PlayerManager.player = self
	# 初始化状态机
	state_machine.initialize(self)
	# 初始化hitbox
	hit_box.damaged.connect(_take_damage)
	update_hp(max_hp)
	pass

func _process(_delta: float) -> void:
	direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass
 
func set_direction() -> bool:
	if direction == Vector2.ZERO:
		return false
	var direction_id : int = int(round((direction + cardinal_direction * 0.1).angle() / TAU * DIR_4.size()))
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	# 改变玩家朝向
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	# 全局通知玩家朝向变动
	direction_changed.emit(new_direction)
	return true

func update_animation(state : String) -> void:
	var next_animation = state + "_" + anim_diretion()
	#print("play animation: %s" % next_animation)
	animation_player.play(next_animation)
	pass
	
func anim_diretion() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage(hurt_box : HurtBox) -> void:
	if invulnerable:
		return
	update_hp(-hurt_box.damage)
	print("player rest hp:" + str(hp))
	if hp > 0: 
		player_damaged.emit(hurt_box)
	else:
		# 先让用户满血
		print("player die:" + str(hp))
		player_damaged.emit(hurt_box)
		update_hp(max_hp)
		print("reset hp:" + str(hp))
	pass
	
func update_hp(delta : int) -> void:
	hp = clampi(hp + delta, 0, max_hp)
	PlayerHud.update_hp(hp, max_hp)
	pass

func make_invulerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
