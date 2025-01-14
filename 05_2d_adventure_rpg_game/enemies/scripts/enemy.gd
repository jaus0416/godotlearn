extends CharacterBody2D
class_name Enemy

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurt_box : HurtBox)
signal enemy_destoryed(hurt_box : HurtBox)

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@export var hp : int = 3

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var hit_box : HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var persistant_is_dead: PersistantDataHandler = $PersistantIsDead

func _ready() -> void:
	state_machine.initialize(self)
	player = PlayerManager.player
	hit_box.damaged.connect(_take_damage)
	
	# 记录存活状态
	persistant_is_dead.data_loaded.connect(free_if_dead)
	free_if_dead()
	pass

func free_if_dead() -> void:
	if persistant_is_dead.value:
		queue_free()
		pass
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
	pass
	
func set_direction(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false
	
	var direction_id : int = int(round(
		(direction + cardinal_direction * 0.1).angle()
		/ TAU * DIR_4.size()
	))
	var new_direction = DIR_4[direction_id]
	
	if new_direction == cardinal_direction:
		return false
	
	cardinal_direction = new_direction
	direction_changed.emit(new_direction)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func update_animation(state : String) -> void:
	var next_animation = state + "_" + anim_diretion()
	#print("enemy[" + name + "] play animation: " + next_animation)
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
	hp -= hurt_box.damage
	
	#print("enemy[" + name + "] rest hp:" + str(hp))
	enemy_damaged.emit(hurt_box)
	if hp <= 0:
		enemy_destoryed.emit(hurt_box)
		# 持久化死亡状态
		persistant_is_dead.set_value()
	pass
